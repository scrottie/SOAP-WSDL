#!/usr/bin/perl -w
package SOAP::WSDL;

use SOAP::Lite;
use vars qw($VERSION @ISA);
use XML::XPath;
use Data::Dumper;

use strict;
use warnings;

@ISA = qw(SOAP::Lite);

$VERSION = "1.23";

# SOAP::Lite has changed the name for speciying a schema in 0.6?
# method before: schema
# method name after: schema_url
#
# Actually, we don't care which SOAP::Lite version there is, so we
# try to support whatever we find...
#
my $SCHEMA_URL = $SOAP::Lite::VERSION >= 0.6 ? 'schema_url' : 'schema';

sub wsdlinit
{
	my $self = shift;
	my %opt  = @_;
	$self->{ _WSDL }->{ cache }           = {};
	$self->{ _WSDL }->{ caching }         = $opt{ caching };
	$self->{ _WSDL }->{ cache_directory } = $opt{ cache_directory }
	  if exists( $opt{ cache_directory } );
	$self->{ _WSDL }->{ checkoccurs } = 1
	  unless defined( $self->{ _WSDL }->{ checkoccurs } );

	if (   ( $self->{ _WSDL }->{ caching } )
		&& ( !$self->{ _WSDL }->{ fileCache } ) )
	{
		$self->wsdl_cache_init();
	}

	#makeup xpath document
	my $xpath;

	# check cache
	if ( $self->{ _WSDL }->{ fileCache } )
	{

		# get xpath from cache
		$xpath = $self->{ _WSDL }->{ fileCache }->get( $self->wsdl );

		# get in-memory cache from cache
		if ( $self->{ _WSDL }->{ caching } )
		{
			my $cache =
			  $self->{ _WSDL }->{ fileCache }->get( $self->wsdl . "_cache" );
			$self->{ _WSDL }->{ cache } = $cache || {};
		} ## end if ( $self->{ _WSDL }->...
	} ## end if ( $self->{ _WSDL }->...
	unless ( $xpath )
	{
		$xpath =
		  XML::XPath->new(
			xml => SOAP::Schema->new( $SCHEMA_URL => $self->wsdl() )->access );
	} ## end unless ( $xpath )

	( $xpath )
	  || die "Error processing WSDL: Cannot create XPath object";

	$self->_wsdl_xpath( $xpath );

	# Get root element (<definitions>) and get
	# default prefix (the root element's one).
	my $definitions = undef;
	$definitions = $xpath->find( '/*[1]' )->shift;

	my $prefix = $definitions->getPrefix;
	$self->_wsdl_wsdlns( $prefix ? $prefix . ':' : '' );

	# get the targetNamespace
	my $tns = $definitions->getAttribute( 'targetNamespace' )
	  || die
	  "Error processing WSDL: cannot get <definition targetNamespace=''>";

	# look for schema namespace & prefix for targetNamespace
	my ( $defaultNS, $schemaNS ) = ( '', '' );
	my @_ns_sub_list = ();

	my $nameSpaces = $definitions->getNamespaces
	  || die "Error processing WSDL: cannot get <definition> namespaces";
	my $nsHash = {};
	foreach my $ns ( @{ $nameSpaces } )
	{
		$xpath->set_namespace( $ns->getPrefix, $ns->getData );
		if ( $ns->getData eq $tns )
		{
			push @_ns_sub_list, $ns->getPrefix;
			next;
		}

		#-------------------------------------------------------
		# Here we look for the default wsdl namespace which is used *only*
		# when we are looking for the arrays  restrictions.
		# Originally the prefix was used for this, but sometimes the prefix
		# can be omitted
		#-------------------------------------------------------
		$ns->getPrefix eq "#default" and next;
		if ( $ns->getData eq "http://schemas.xmlsoap.org/wsdl/" )
		{
			$self->_wsdl_wsdlExplicitNS(
				$ns->getPrefix ? $ns->getPrefix . ":" : "" );
		}

		# the schema namespace is hardcoded in to the SOAP::Constants package,
		# in the Lite.pm module
		if ( defined $SOAP::Constants::XML_SCHEMAS{ $ns->getData }
			and $SOAP::Constants::XML_SCHEMAS{ $ns->getData } =~
			/SOAP::XMLSchema\d+/ )
		{
			$schemaNS = $ns->getPrefix;
		} ## end if ( defined $SOAP::Constants::XML_SCHEMAS...
		$nsHash->{ $ns->getData } = $ns->getPrefix . ':';
	} ## end foreach my $ns ( @{ $nameSpaces...

	$self->_wsdl_ns( $nsHash );
	$defaultNS = join( '|', @_ns_sub_list );

	$self->_wsdl_tns( $defaultNS );
	$self->_wsdl_tns_uri( $tns );
	$self->_wsdl_schemans( $schemaNS );

	#---
	#-- TBD: remove all the hardcoded urls
	$self->_wsdl_soapns(
		$self->_wsdl_ns->{ 'http://schemas.xmlsoap.org/wsdl/soap/' } );

	#the default namespaces for types
	$self->{ _WSDL }->{ _type_ns } = "";
	$self->_wsdl_schemans
	  and $self->{ _WSDL }->{ _type_ns } .= $self->_wsdl_schemans . ":|";

	#TBD: the apache soap special case has to be handled elsewhere
	$nsHash->{ 'http://xml.apache.org/xml-soap' }
	  and $self->{ _WSDL }->{ _type_ns } .=
	  $nsHash->{ 'http://xml.apache.org/xml-soap' } . "|";
	chop $self->{ _WSDL }->{ _type_ns };

	$self->servicename( $opt{ servicename } ) if ( $opt{ servicename } );
	$self->portname( $opt{ portname } )       if ( $opt{ portname } );

	# return something useful to ease testing...
	return $self;

} ## end sub wsdlinit

sub _wsdl_init_port
{
    my $self = shift;
    my $name = shift;
    my $opt = shift;
    my $xpath = $self->_wsdl_xpath;
    my $tns = $self->_wsdl_tns;

    # Step one: get <service><port...> element
    #
    # This provides us with the address (enpoint/proxy), which we set here
    # and the binding name.

    # Fetch <soap:address from inside <wsdl:port -
    # so we get both with one xpath query...
    my $path =  '/' . $self->_wsdl_wsdlns()
          . 'definitions/'
          . $self->_wsdl_wsdlns() .'service[@name="' . $self->servicename()
          . '"]/'
          . $self->_wsdl_wsdlns() . 'port[@name="' . $name . '"]/'
          . $self->_wsdl_soapns() . 'address';

    my $address = $xpath->find( $path )->shift
       || die "Error processing WSDL file - no such port ($path)";
    my $endpoint = $address->getAttribute( 'location' )
        or die "No endpoint address found ($path)";

    $self->proxy( $endpoint );

    my $port = $address->getParentNode();
    my $binding_name = $port->getAttribute( 'binding' );

    # Step two: get the correct <binding...> element.
    # This provides us with the portType name.
    # Remember binding for later usage (in call() ) and
    #

    # remove the default targetNamespace from messageName
    $binding_name =~ s/^($tns)\:*//;

    $path = join(
        $self->_wsdl_wsdlns,
        (
            '/',
            'definitions/',
            'binding[@name="' . $binding_name . '"]',
        )
    );

    my $binding = $xpath->find( $path )->shift()
        or die "no binding found ($path)";

    $self->{ _WSDL }->{ binding } = $binding;

    my $portType_name = $binding->getAttribute( 'type' );

    # remove the default targetNamespace from messageName
    $portType_name =~ s/^($tns)\:*//;

    $path = join(
          $self->_wsdl_wsdlns,
          (
            '/',
            'definitions/',
            'portType[@name="' . $portType_name . '"]',
          )
    );

    # warn("looking for $path");
    my $portType = $xpath->find( $path )->shift()
        or die "No portType found ($path)";
    $self->{ _WSDL }->{ portType } = $portType;

}

sub call
{
	my $self   = shift;
	my $method = shift;
	my %data   = @_;

	my $path;
	my $location;
	my $mode = 'input';

	my $tns = $self->_wsdl_tns;
	my $ns  = $self->_wsdl_ns;

	my $xpath = $self->_wsdl_xpath;

	( $xpath ) || do
	{
		$self->wsdlinit;
		$xpath = $self->_wsdl_xpath
		  || die "Error processing WSDL: no wsdl object";
	};

    # get the first port if none has been set...
    $self->_get_first_port() if (not $self->portname() );

    # initialize port if not done yet
    $self->_wsdl_init_port( $self->portname() )
        if ( not $self->_wsdl_portType() );

	my $portType = $self->_wsdl_portType();
	my $binding = $self->_wsdl_binding();

	$path = join(
		$self->_wsdl_wsdlns,
		(
			# '/',
			'operation[@name="' . $method . '"]/',
            $mode
		)
	);

	#overload: the user has provided a the input name for us
	$data{ "wsdl_${mode}_name" }
	  and $path .= "[\@name='" . $data{ "wsdl_${mode}_name" } . "']";

    # warn "Looking for operation $path";
    my $inputMessageName;
    my $binding_operation_message = $binding->find( $path )->shift();
    if ($binding_operation_message)
    {
        my $binding_operation = $binding_operation_message->getParentNode();
        my $soapAction = $binding_operation->getAttribute( 'soapAction' );
        $self->on_action( sub { return "$soapAction" } ) if ($soapAction);
        # warn "soapAction set to $soapAction\n";

        #if defined, the input message name has to be the leading item
        #in the SOAP call. If not defined, it has to be the operation
        #name. In the case of overloaded calls, it *IS* the parameter passed
        #by the calling script. So

        if ( $data{ "wsdl_${mode}_name" } )
        {
                $inputMessageName = $data{ "wsdl_${mode}_name" };
        }
        else
        {
                $inputMessageName = $binding_operation_message->getAttribute('name');
        }

    }
    # just set it right if not set before:
	$inputMessageName ||= $method;

	$path = join(
		$self->_wsdl_wsdlns,
		(
			'/',
            'definitions/',
			'binding[@name="' . $binding->getAttribute('name') . '"]/',
            'operation[@name="' . $method . '"]/',
			"$mode/"
		)
	  )
	  . $self->_wsdl_soapns . "body";

    # warn "looking for $path...";
    my $callNamespace;
    my $encodingStyle = q{};
    if (my $operation = $self->_wsdl_find( $path )->shift)
    {
        # warn "found operation:" . Dumper $operation;
        #a call can have an associated, namespace
	    $callNamespace = $operation->getAttribute('namespace');
        #the encoding style is required when handling restricted complextypes
        $encodingStyle = $operation->getAttribute( 'encodingStyle' );
    }
	$callNamespace ||= $self->_wsdl_tns_uri;

    $self->wsdl_encoding( $self->_wsdl_ns->{ $encodingStyle } )
        if ($encodingStyle);

	$path = join(
		$self->_wsdl_wsdlns,
		(
			'/', 'definitions/',
			'portType[@name="' . $portType->getAttribute('name') . '"]/',
			'operation[@name="' . $method . '"]/',
            $mode
		)
	);

	# overload: the calling script has to say wich overloading
	# procedure call has to be encoded and forwarded to the server

	$data{ "wsdl_${mode}_name" }
	  and $path .= "[\@name='" . $data{ "wsdl_${mode}_name" } . "']";

	$path .= "/\@message";
	my $messageName = $self->_wsdl_findvalue( $path, "dieIfError" );

	$messageName =~ s/^($tns)\:*//;

	$path = join(
		$self->_wsdl_wsdlns,
		( '/', 'definitions/', 'message[@name="' . $messageName . '"]/'
        , 'part' )
	);

    # warn "looking for $path...";

    # An operation without parts is equivalent to a procedure
    # call without parameters
    # Though not very common, messages may have more than one part...
	my $parts = $self->_wsdl_find( $path );

	my @param = ();
	while ( my $part = $parts->shift )
	{
		my @enc = $self->encode( $part, \%data );
		push @param, @enc if ( @enc );
	}

	my $methodEncoded =
	  SOAP::Data->name( $inputMessageName )
	  ->attr( { "xmlns" => $callNamespace } );
	unless ( $self->{ _WSDL }->{ no_dispatch } )
	{
		return $self->SUPER::call(
			$methodEncoded => @param,
			@{ $data{ soap_headers } }
		);
	} ## end unless ( $self->{ _WSDL }->...
	else
	{
		return $methodEncoded, @param;
	}
} ## end sub call

# find the first servie and port for convenience

sub _get_first_port
{
	my $self  = shift;
	my $url   = shift;
	my $xpath = $self->_wsdl_xpath();

    # find /wsdl:definitions/wsdl:service/wsdl:port/soap:address
    # use namespace prefixes from WSDL - they may differ...
    #
    # We head right for the address instead of just fetching the first
    # port - we want to set the SOAP::Lite proxy, and accessing
    # our parent is easier than running repeated XPath queries...
    #
	my $path =  '/' . $self->_wsdl_wsdlns() .
	  'definitions/'
          . $self->_wsdl_wsdlns() .'service/'
          . $self->_wsdl_wsdlns() . 'port/'
          . $self->_wsdl_soapns() . 'address';

	my @ports = $xpath->findnodes( $path );

	return if ( not @ports );

	my $address = shift @ports;
	my $port    = $address->getParentNode();
	my $service = $port->getParentNode();
	$self->servicename( $service->getAttribute( 'name' ) );
	$self->portname( $port->getAttribute( 'name' ) );

	return $self;
} ## end sub _get_first_port

sub DESTROY
{
	my $self = shift;
	$self->wsdl_cache_store();
	return 1;
}

#a sort of autoload for the store-and-return methods
sub _load_method
{
	my $method = shift;
	my $param  = shift;
	no strict "refs";
	*$method = sub {
		my $self = shift;
		return ( @_ ) ? $self->{ _WSDL }->{ $param } = shift
		  : $self->{ _WSDL }->{ $param } ? $self->{ _WSDL }->{ $param }
		  : "";
	};
} ## end sub _load_method

sub portname {
    my $self = shift;
    if ( @_ )
    {
        my $portname = shift;
        if ( not defined($self->{ _WSDL }->{ portname })
            or ($portname ne ($self->{ _WSDL }->{ portname }) ) )
        {
            $self->{ _WSDL }->{ portname } = $portname;
            $self->_wsdl_init_port( $portname );
        }
    }
    if ($self->{ _WSDL }->{ 'portname' })
    {
        return $self->{ _WSDL }->{ 'portname' }
    };
    return;
}

&_load_method( "no_dispatch",          "no_dispatch" );
&_load_method( "wsdl",                 "wsdl" );
&_load_method( "wsdl_checkoccurs",     "checkoccurs" );
&_load_method( "servicename",          "servicename" );
#&_load_method( "portname",             "portname" );
&_load_method( "wsdl_cache_directory", "cache_directory" );
&_load_method( "wsdl_encoding",        "wsdl_encoding" );
&_load_method( "_wsdl_ns",             "namespaces" );
&_load_method( "_wsdl_xpath",          "xpath" );
&_load_method( "_wsdl_tns",            "tns" );
&_load_method( "_wsdl_tns_uri",        "tns_uri" );
&_load_method( "_wsdl_wsdlns",         "wsdlns" );
&_load_method( "_wsdl_schemans",       "schemans" );
&_load_method( "_wsdl_soapns",         "soapns" );
&_load_method( "_wsdl_wsdlExplicitNS", "wsdl_wsdlExplicitNS" );
&_load_method( "_wsdl_binding",         "binding" );
&_load_method( "_wsdl_portType",         "portType" );

#each call to make finder returns a wrapped version of the xpath calls.
#find, findvalue, findnodes and so on
#the cache checking part is hidden here
sub _make_finder()
{
	my ( $method, $call ) = @_;
	no strict "refs";
	*$method = sub {
		my $self = shift;
		my ( $path, $dieIfError ) = @_;
		my $data = "";

		$data = $self->{ _WSDL }->{ cache }->{ $path };
		unless ( $data )
		{
			$data = $self->_wsdl_xpath->$call( $path );
			$self->{ _WSDL }->{ cache }->{ $path } = $data
			  if ( $self->{ _WSDL }->{ caching } );
		} ## end unless ( $data )
		if ( !$data )
		{
			$dieIfError
			  and
			  print( "Error processing WSDL: can't find the path '$path'\n" ),
			  exit;
		} ## end if ( !$data )
		return $data;
	};
} ## end sub _make_finder()

&_make_finder( "_wsdl_find",      "find" );
&_make_finder( "_wsdl_findvalue", "findvalue" );
&_make_finder( "_wsdl_findnodes", "findnodes" );

sub wsdl_cache_store
{
	my $self = shift;
	if (   ( $self->{ _WSDL }->{ cache_directory } )
		&& ( $self->{ _WSDL }->{ fileCache } ) )
	{
		$self->{ _WSDL }->{ fileCache }
		  ->set( $self->wsdl, $self->{ _WSDL }->{ xpath } );
		$self->{ _WSDL }->{ fileCache }
		  ->set( $self->wsdl . "_cache", $self->{ _WSDL }->{ cache } );
	} ## end if ( ( $self->{ _WSDL ...
} ## end sub wsdl_cache_store

sub wsdl_cache_init
{
	my $self  = shift;
	my $p     = shift || {};    # get custom params - or none...
	my $cache = undef;
	eval { require Cache::FileCache; };
	if ( $@ )
	{
		# warn about missing Cache::FileCache and set cache hadnle to undef
		warn "File caching is enabled, but you do not have the "
		  . "Cache::FileCache module. Disabling Filesystem caching."
		  if ( $self->{ _WSDL }->{ cache_directory } );
		$self->{ _WSDL }->{ fileCache } = undef;
	} ## end if ( $@ )
	else
	{
		# initialize cache from custom parameters if given
		$p->{ cache_root } ||= $self->{ _WSDL }->{ cache_directory };
		$cache = Cache::FileCache->new( $p );
	} ## end else [ if ( $@ )
	$self->{ _WSDL }->{ fileCache } = $cache;
} ## end sub wsdl_cache_init

sub encode
{

	my $self = shift;
	my $part = shift;
	my $data = shift;

	my $schemaNS  = $self->_wsdl_schemans ? $self->_wsdl_schemans . ':' : '';
	my $defaultNS = $self->{ _WSDL }->{ tns };

	my %nsHash = reverse %{ $self->_wsdl_ns };
	my %nsURIs = %{ $self->_wsdl_ns };

	#TBD: Caching hook ?
	my $p = {
		name     => $part->findvalue( '@name' )->value,
		type     => $part->findvalue( '@type' )->value,
		element  => $part->findvalue( '@element' )->value,
		xmlns    => $part->findvalue( '@targetNamespace' )->value,
		nillable => $part->findvalue( '@nillable' )->value,
	};

	my $result   = undef;
	my $order    = undef;
	my $typeName = undef;
	my $typeNS   = "";
	my $type     = "";

	my $default = $part->findvalue( '@default' )->value;
	if ( $default eq "0" or $default )
	{
		$p->{ default } = $default;
	}

	if ( ( $p->{ type } ) )
	{
		if ( $p->{ type } =~ m!($defaultNS):(.*)! )
		{
			$typeName = $2;

			#looking for type restrictions
			my $path = join( $self->_wsdl_wsdlns,
				'/', 'definitions/', "types/${schemaNS}schema/" )
			  . "${schemaNS}simpleType[\@name='$typeName']/"
			  . "${schemaNS}restriction" . "|"
			  . join( $self->_wsdl_wsdlns,
				'/', 'definitions/', "types/${schemaNS}schema/" )
			  . "${schemaNS}complexType[\@name='$typeName']/${schemaNS}complexContent/"
			  . "${schemaNS}restriction";

			#usually there is only one restriction
			#my $simpleType = $self->{_WSDL}->{xpath}->find($path)->shift;
			my $simpleType = $self->_wsdl_find( $path, "" )->shift;
			$simpleType
			  and my $baseType = $simpleType->findvalue( '@base' )->value;

			#TBD: verify if the data matches the restrictions
			#--
			#now we have (hopely) the base type
			my $wsdl_encoding = $self->wsdl_encoding();

			if ( defined( $baseType )
				and $baseType eq $wsdl_encoding . "Array" )
			{

				#the type is an array restricted  of something
				#--
				$type = $baseType;
				$type =~ s/^$schemaNS/xsd:/;

				#--

				#if the basetype is Array then we ask: Array of what?
				#only complexTypes can be restricted to an Array
				my $path = join( $self->_wsdl_wsdlns,
					'/', 'definitions/', "types/${schemaNS}schema/" )
				  . "${schemaNS}complexType[\@name='$typeName']/${schemaNS}complexContent/"
				  . "${schemaNS}restriction/"
				  . "${schemaNS}attribute";

				my $simpleType =
				  $self->{ _WSDL }->{ xpath }->find( $path )->shift;
				$simpleType
				  and $baseType =
				  $simpleType->findvalue(
					'@' . ( $self->_wsdl_wsdlExplicitNS ) . 'arrayType' )
				  ->value;

				#and now we have (eventually) the base type
				$baseType =~ s/..$//;
			} ## end if ( defined( $baseType...
			$baseType and $p->{ type } = $baseType;
		} ## end if ( $p->{ type } =~ m!($defaultNS):(.*)!...

		#Now, we have p, and p has a type
		#and the type of p is (eventually) extracted from some restriction

		#In order to get the correct type, now we have to handle the imported
		#namespaces. Some wsdl files have multiple schema declaration.
		#And each declaration can have her own imported namespaces.
		#Plainly: for each type check we have to check the schemas chain
		#in order to get the imported namespaces for *that* schema

		#- _type_ns contains the typical default namespaces
		$typeNS = $self->{ _WSDL }->{ _type_ns };

		$p->{ type } =~ /(.*:)(.*)/;
		if ( $1 ne $schemaNS )
		{

			#the type of p don't belongs to some default schema type
			#first we look after the schema who owns our type
			my $path = join( $self->_wsdl_wsdlns,
				'/', 'definitions/', "types/${schemaNS}schema/" )
			  . "*[\@name='$2']";

			my $schema = $self->_wsdl_find( "$path/..", "" )->shift;
			my $nodeSet =
			  $self->_wsdl_find(
				"$path/preceding-sibling::${schemaNS}import" );
			while ( my $node = $nodeSet->shift )
			{
				no warnings;
				$typeNS .= "|"
				  . $self->_wsdl_ns->{ $node->getAttribute( 'namespace' ) };
			} ## end while ( my $node = $nodeSet...

#if the schema has a default nameSpace, it has to be added to the added to dhe typeNs list

			my $schemaTargetNS = $schema->findvalue( '@targetNamespace' );
			if ( $schemaTargetNS )
			{
				defined $self->_wsdl_ns->{ $schemaTargetNS }
				  and $typeNS .= "|" . $self->_wsdl_ns->{ $schemaTargetNS };
			}
		} ## end if ( $1 ne $schemaNS )

		if ( $p->{ type } =~ m/^$typeNS/ )
		{    #it's a simple type

			#symple types can have default values
			if (   !exists $data->{ $p->{ name } }
				or !defined $data->{ $p->{ name } } )
			{
				if ( defined $p->{ default } )
				{
					$data->{ $p->{ name } } = $p->{ default };
				}
			} ## end if ( !exists $data->{ ...

			#-- this stuff is supposed to check the occurrences
			my $count = -1;
			if ( $self->{ _WSDL }->{ checkoccurs } )
			{
				$count =
				    exists $data->{ $p->{ name } }
				  ? defined $data->{ $p->{ name } }
				  ? ref $data->{ $p->{ name } } eq 'ARRAY'
				  ? scalar @{ $data->{ $p->{ name } } }
				  : 1
				  : 0
				  : 0;

				$order = $part->getParentNode()->getName;
				$p->{ minOccurs } = $part->findvalue( '@minOccurs' )->value;
				if (   ( !defined( $p->{ minOccurs } ) )
					|| ( $p->{ minOccurs } eq "" ) )
				{
					if ( $order eq 'sequence' )
					{
						$p->{ minOccurs } = 1;
					}
					elsif ( $order eq 'all' )
					{
						$p->{ minOccurs } = 0;
					}
					else
					{
						$p->{ minOccurs } = 0;
					}
				} ## end if ( ( !defined( $p->{...

				$p->{ maxOccurs } = $part->findvalue( '@maxOccurs' )->value;
				if (   ( !defined( $p->{ maxOccurs } ) )
					|| ( $p->{ maxOccurs } eq "" ) )
				{
					if    ( $order eq 'sequence' ) { $p->{ maxOccurs } = 1 }
					elsif ( $order eq 'all' )      { $p->{ maxOccurs } = 1 }
					else { $p->{ maxOccurs } = undef }
				} ## end if ( ( !defined( $p->{...
				$p->{ maxOccurs } = undef
				  if ( defined( $p->{ maxOccurs } )
					&& $p->{ maxOccurs } eq 'unbounded' );
			} ## end if ( $self->{ _WSDL }->...

			# check for ocurrence ?
			# acceptable number of value ?
			if (
				( !$self->{ _WSDL }->{ checkoccurs } )
				|| (   ( $p->{ minOccurs } <= $count )
					|| ( $p->{ nillable } eq "true" ) )
				&& (   ( !defined( $p->{ maxOccurs } ) )
					|| ( $count <= $p->{ maxOccurs } ) )
			  )
			{

				# not nillable
				# empty value
				( !$p->{ nillable } )
				  && ( ( !( exists $data->{ $p->{ name } } ) )
					|| ( !( defined $data->{ $p->{ name } } ) ) )
				  && do
				{
					return ();
				};

				# some value

				# SOAP::Lite uses the "xsd" prefix for specifying schema NS
				my $type = $p->{ type };
				$type =~ s/^$schemaNS/xsd:/;
				$result = SOAP::Data->new( name => $p->{ name } );
				$result->type( $type ) if ( $self->autotype );
				$result->attr( { xmlns => $p->{ xmlns } } ) if $p->{ xmlns };
				return ( $result->value( $data->{ $p->{ name } } ) );
			} ## end if ( ( !$self->{ _WSDL...
			else
			{
				no warnings;
				die "illegal number of elements ($count, min: "
				  . $p->{ minOccurs }
				  . ", max: ."
				  . $p->{ maxOccurs }
				  . ") for element '$p->{ name }' (may be sub-element) ";
			} ## end else [ if ( ( !$self->{ _WSDL...

		} ## end if ( $p->{ type } =~ m/^$typeNS/...
		else
		{    ### must be a complex type
			### get complex type
			my $type = $p->{ type };
			$type =~ s/^($defaultNS)\://;    #
			$type =~ s/^(.+?\:)?//;
			my $path;
			{
				no warnings;

				$path = '/'
				  . $self->_wsdl_wsdlns
				  . 'definitions/'
				  . $self->_wsdl_wsdlns
				  . "types/${schemaNS}schema/"
				  . "${schemaNS}complexType[\@name='$type']" . '|' . '/'
				  . $self->_wsdl_wsdlns
				  . 'definitions/'
				  . $self->_wsdl_wsdlns
				  . "types/schema[\@xmlns='"
				  . $nsHash{ $schemaNS }
				  . "' and \@targetNameSpace = '"
				  . $nsHash{ $1 } . "' ]/"
				  . "complexType[\@name='$type']";
			};

			my $complexType = $self->_wsdl_find( $path, "dieIfError" )->shift;

			### handles arrays of complex types
			### TBD: check for min /max number of elements
			if ( ref $data->{ $p->{ name } } eq 'ARRAY' )
			{

		  #$data says: look, in this position I have for you an array of stuff
				my @resultArray = ();
				foreach my $subdata ( @{ $data->{ $p->{ name } } } )
				{
					$result = SOAP::Data->new( name => $p->{ name } );
					$result->type( $type ) if ( $self->autotype );
					$result->attr( { xmlns => $p->{ xmlns } } )
					  if $p->{ xmlns };
					my $value =
					  $self->_encodeComplexType( $complexType, $subdata );
					push @resultArray, $result->value( $value )
					  if ( defined( $value ) );
				} ## end foreach my $subdata ( @{ $data...
				return ( @resultArray ) ? @resultArray : ();
			} ## end if ( ref $data->{ $p->...
			else
			{
				$result = SOAP::Data->new( name => $p->{ name } );

			  #.Net compatibility $result->type( $type ) if ($self->autotype);
				$result->attr( { xmlns => $p->{ xmlns } } ) if $p->{ xmlns };
				my $value;

				#
				if ( $data->{ $p->{ name } } )
				{    #we have some data to encode
					$value =
					  $self->_encodeComplexType( $complexType,
						$data->{ $p->{ name } } );
				} ## end if ( $data->{ $p->{ name...
				else
				{
					$p->{ minOccurs } =
					  $part->findvalue( '@minOccurs' )->value;
					if ( $p->{ minOccurs } ne '' and $p->{ minOccurs } > 0 )
					{

					  #this element is required, but we have no data to encode
					  #it's an error
						die "illegal number of elements (0, min: "
						  . $p->{ minOccurs }
						  . ", for element '$p->{ name }' (may be sub-element) ";
					} ## end if ( $p->{ minOccurs }...
				} ## end else [ if ( $data->{ $p->{ name...
				return () unless ( defined( $value ) );
				return ( $result->value( $value ) );
			} ## end else [ if ( ref $data->{ $p->...
		} ## end else [ if ( $p->{ type } =~ m/^$typeNS/...
	} ## end if ( ( $p->{ type } ) ...
	elsif ( $p->{ element } )
	{

		#if p has no type, then must be an an element (or an error)
		#which one?
		my $elementPath = $p->{ element };

		$elementPath =~ s/^$defaultNS\://;

		# there are two ways how schema are usually defined
		my $path = '/'
		  . $self->_wsdl_wsdlns
		  . 'definitions/'
		  . $self->_wsdl_wsdlns
		  . 'types/'
		  . $schemaNS
		  . 'schema/'
		  . $schemaNS
		  . 'element[@name="'
		  . $elementPath . '"]/'
		  . $schemaNS
		  . 'complexType/'
		  . 'descendant::'
		  . $schemaNS
		  . 'element';

		my $elements = $self->_wsdl_findnodes( $path, "dieIfError" );

		my @resultArray = ();
		while ( my $e = $elements->shift )
		{
			my @enc;
			@enc = $self->encode( $e, $data );
			push @resultArray, @enc if ( @enc );
		} ## end while ( my $e = $elements...
		return ( @resultArray ) ? @resultArray : ();
	} ## end elsif ( $p->{ element } )
	else
	{

		#typical case when coping with .Net generated wsdl files
		( $p->{ name } eq "anyType" )
		  and print
"Oops, have you defined an ArrayOfAnyType without the Type? Try type=[namespace]:anyType\n";
		die "illegal part definition\n";
	} ## end else [ if ( ( $p->{ type } ) ...
	return ();    # if we got here, something went wrong...
} ## end sub encode

sub _encodeComplexType
{
	my $self        = shift;
	my $complexType = shift;
	my $data        = shift;
	my @result      = ();
	my $schemaNS  = $self->_wsdl_schemans ? $self->_wsdl_schemans . ':' : '';
	my $defaultNS = $self->_wsdl_tns;
	my %nsHash    = reverse %{ $self->_wsdl_ns };

	#-- first we encode the local elements ....
	my $path     = './/' . $schemaNS . 'element';
	my $elements = $complexType->find( $path );
	while ( my $e = $elements->shift )
	{
		my @enc;
		@enc = $self->encode( $e, $data );
		push @result, @enc if ( @enc );
	} ## end while ( my $e = $elements...

	my $extension = undef;
	### check for extension
#%baseList avoids loops while looking at the extensions chain, just a flag holder
	my %baseList = ();

	#... and then we cope with the chain of extensions
	while ( $extension =
		$complexType->find( './/' . $schemaNS . 'extension' )->shift )
	{
		### pull in extension base
		my $base = $extension->findvalue( '@base' );
		$base =~ s/^$defaultNS\://;
		$base =~ s/^(.+?\:)//;

		#-
		last if ( $baseList{ $base } );    #got a loop
		$baseList{ $base } = 1;

		#-
		my $path;
		{
			no warnings;

			# there are two ways how schema are usually defined
			$path = '/'
			  . $self->_wsdl_wsdlns
			  . 'definitions/'
			  . $self->_wsdl_wsdlns
			  . "types/"
			  . $schemaNS
			  . "schema/"
			  . $schemaNS
			  . "complexType[\@name='$base']" . '|' . '/'
			  . $self->_wsdl_wsdlns
			  . 'definitions/'
			  . $self->_wsdl_wsdlns
			  . "types/schema[\@xmlns='"
			  . $nsHash{ $schemaNS }
			  . "' and \@targetNameSpace = '"
			  . $nsHash{ $1 } . "' ]/"
			  . "complexType[\@name='$base']";
		}

		$complexType = $self->_wsdl_find( $path, "dieIfError" )->shift;

		#now we can find the elements
		$path = ".//" . $schemaNS . "element|.//element";
		my $elements = $complexType->find( $path )
		  || die "Error processing WSDL: '$path' not found";

		while ( my $e = $elements->shift )
		{
			my @enc;
			@enc = $self->encode( $e, $data );
			push @result, @enc if ( @enc );
		} ## end while ( my $e = $elements...
	} ## end while ( $extension = $complexType...
	return ( @result ) ? \SOAP::Data->value( @result ) : ();
} ## end sub _encodeComplexType

1;

__END__

=pod

=head1 NAME

SOAP::WSDL - SOAP with WSDL support

=head1 SYNOPSIS

 use SOAP::WSDL;

 my $soap = SOAP::WSDL->new( wsdl => 'http://server.com/ws.wsdl' );
 $soap->wsdlinit();
 $soap->servicename( 'myservice' );
 $soap->portname( 'myport' );

 my $som = $soap->call( 'method' =>  (
                   name => 'value' ,
                   name => 'value' ) );


=head1 DESCRIPTION

This is mainly a bugfix update to 1.22, which was a small update to 1.21
- autodetection of servicename and portname have been
are re-introduced, so users of 1.20 have no need to change their scripts.

1.21 was a new version of SOAP::WSDL, mainly based on the work of
Giovanni S Fois.

SOAP::WSDL provides WSDL support for SOAP::Lite.
It is built as a add-on to SOAP::Lite, and will sit on top of it,
forwarding all the actual request-response to SOAP::Lite - somewhat
like a pre-processor.

WSDL support means that you don't have to deal with those bitchy namespaces
some web services set on each and every method call parameter.

It also means an end to that nasty

 SOAP::Data->name( 'Name' )->value(
    SOAP::Data->name( 'Sub-Name')->value( 'Subvalue' )
 );

encoding of complex data. (Another solution for this problem is just iterating
recursively over your data. But that doesn't work if you need more information
[e.g. namespaces etc] than just your data to encode your parameters).

And it means that you can use ordinary hashes for your parameters - the
encording order will be derived from the WSDL and not from your (unordered)
data, thus the problem of unordered  perl-hashes and WSDL E<gt>sequenceE<lt>
definitions is solved, too. (Another solution for the ordering problem is
tying your hash to a class that provides ordered hashes - Tie::IxHash is
one of them).

=head2 Why should I use this ?

SOAP::WSDL eases life for webservice developers who have to communicate with
lots of different web services using a reasonable big number of method calls.

If you just want to call a hand full of methods of one web service, take
SOAP::Lite's stubmaker and modify the stuff by hand if it doesn't work right
from the start. The overhead SOAP::WSDL imposes on your calls is not worth
the time saving.

If you need to access many web services offering zillions of methods to you,
this module should be your choice. It automatically encodes your perl data
structures correctly, based on the service's WSDL description, handling
even those complex types SOAP::Lite can't cope with.

SOAP::WSDL also eliminates most perl E<lt>-E<gt> .NET interoperability
problems by qualifying method and parameters as they are specified in the
WSDL definition.

=head1 USAGE

 my $soap=SOAP::WSDL->new( wsdl => 'http://server.com/ws.wsdl' );

 # or
 my $soap=SOAP::WSDL->new()
 $soap->wsdl('http://server.com/ws.wsdl');

 # or
 # without dispatching calls to the WebService
 #
 # useful for testing
 my $soap=SOAP::WSDL->new( wsdl => 'http://server.com/ws.wsdl',
 		no_dispatch => 1 );

 # never forget to call this !in order to start the parsing procedure
 $soap->wsdlinit();

 # with caching enabled:don't forget the cache directory
 $soap->wsdlinit( caching => 1, cache_directory =>"/tmp/cachedir");

 # optional, set to a false value if you don't want your
 # soap message elements to be typed
 $soap->autotype(0);

 # you may specify a service and port - if not, SOAP::WSDL will search for
 # the first one appearing in the WSDL
 $soap->servicename('myservice');
 $soap->portname('myport');

 my $som=$soap->call( 'method' ,
                   name => 'value' ,
                   name => 'value'  );


 # with the method overloaded (got it from the standard)
 my $som=$soap->call( 'method' ,
                   wsdl_input_name => unique_input_message_name
                   name => 'value' ,
                   name => 'value'  );

  # with headers (see the SOAP documentation)

 #first define your headers
 @header = (SOAP::Header->name("FirstHeader")->value("FirstValue"),
    SOAP::Header->name("SecontHeader")->value("SecondValue"));

 #and then do the call. please note the backslash
 my $som=$soap->call( 'method' ,
                   name => 'value' ,
                   name => 'value' ,
                   "soap_headers" => \@header);


=head1 How it works

SOAP::WSDL takes the wsdl file specified and looks up the service and the
specified port.

On calling a SOAP method, it looks up the message encoding and wraps all the
stuff around your data accordingly.

Most pre-processing is done in I<wsdlinit>, the rest is done in I<call>, which
overrides the same method from SOAP::Lite.

=head2 wsdlinit

SOAP::WSDL loads the wsdl file specified by the wsdl parameter / call using
SOAP::Lite's schema method. It sets up a XPath object of that wsdl file, and
subsequently queries it for namespaces, service, and port elements.

SOAP::WSDL automatically uses the first service and port found in the WSDL.

If you want to chose a different one, you can specify the service by calling

 $soap->servicename('ServiceToUse');
 $soap->portname('PortToUse');

=head2 call

The call method examines the wsdl file to find out how to encode the SOAP
message for your method. Lookups are done in real-time using XPath, so this
incorporates a small delay to your calls (see
L</Memory consumption and performance> below.

The SOAP message will include the types for each element, unless you have
set autotype to a false value by calling

 $soap->autotype(0);

After wrapping your call into what is appropriate, SOAP::WSDL uses the
I<call()> method from SOAP::Lite to dispatch your call.

call takes the method name as first argument, and the parameters passed to
that method as following arguments.

B<Example:>

 $som=$soap->call( "SomeMethod" , "test" => "testvalue" );

 $som=$soap->call( "SomeMethod" => %args );

=head1 Caching

SOAP::WSDL uses a two-stage caching mechanism to achieve best performance.

First, there's a pretty simple caching mechanisms for storing XPath query
results.

They are just stored in a hash with the XPath path as key (until recently,
only results of "find" or "findnodes" are cached). I did not use the obvious
L<Cache|Cache> or L<Cache::Cache|Cache::Cache>  module here, because these
use L<Storable|Storable> to store complex objects and thus incorporate a
performance loss heavier than using no cache at all.

Second, the XPath object and the XPath results cache are be stored on disk
using the L<Cache::FileCache|Cache::FileCache> implementation.

A filesystem cache is only used if you

 1) enable caching
 2) set wsdl_cache_directory

The cache directory must be, of course, read- and writeable.

XPath result caching doubles performance, but increases memory consumption
- if you lack of memory, you should not enable caching (disabled by default).

Filesystem caching triples performance for wsdlinit and doubles performance
for the first method call.

The file system cache is written to disk when the SOAP::WSDL object is
destroyed.

It may be written to disk any time by calling the L</wsdl_cache_store> method.

Using both filesystem and in-memory caching is recommended for best
performance and smallest startup costs.

=head2 Sharing cache between applications

Sharing a file system cache among applications accessing the same web
service is generally possible, but may under some circumstances reduce
performance, and under some special circumstances even lead to errors.
This is due to the cache key algorithm used.

SOAP::WSDL uses the WSDL's URL to store the XML::XPath object of the
wsdl file. If you're using more than one WSDL definition on the same URL,
this may lead to errors when two or more applications using SOAP::WSDL
share a file system cache.

SOAP::WSDL stores the XPath results in-memory-cache in the filesystem cache,
using the URL wsdl file with C<_cache> appended. Two applications sharing the
file system cache and accessing different methods of one web service could
overwrite each others in-memory-caches when dumping the XPath results to
disk, resulting in a slight performance drawback (even though this only
happens in the rare case of one app being started before the other one has
had a chance to write its cache to disk).

=head2 Controlling the file system cache

If you want full controll over the file system cache, you can use wsdl_init_cash to
initialize it. wsdl_init_cash will take the same parameters as Cache::FileCache->new().
See L<Cache::Cache> and L<Cache::FileCache> for details.

=head2 Notes

If you plan to write your own caching implementation, you should consider the following:

The XPath results cache must not survive the XPath object SOAP::WSDL uses to
store the WSDL file in (this could cause memory holes - see
L<XML::XPath|XML::XPath> for details).
This never happens during normal usage - but note that you have been warned
before trying to store and re-read SOAP::WSDL's internal cache.

=head1 Methods

=head2 Frequently used methods

=head3 wsdl

 $soap->wsdl('http://my.web.service.com/wsdl');

Use this to specify the WSDL file to use. Must be a valid (and accessible !)
url.

You must call this before calling L</wsdlinit>.

For time saving's sake, this should be a local file - you never know how much
time your WebService needs for delivering a wsdl file.

=head2 wsdlinit

 $soap->wsdlinit( caching => 1,
 	cache_directory => '/tmp/cache' );

Initializes the WSDL document for usage.

wsdlinit will die if it can't set up the WSDL file properly, so you might
want to eval{} it.

On death, $@ will (hopefully) contain some error message like

 Error processing WSDL: no <definitions> element found

to give you a hint about what went wrong.

wsdlinit will accept a hash of parameters with the following keys:

=over 4

=item * caching

enables caching if true

=item * cache_directory

The cache directory to use for FS caching

=item * url

URL to derive port and service name from. If url is given, wsdlinit will try
to find a matching service and port in the WSDL definition.

=item * servicename

like setting the servicename directly. See <servicename|servicename> below.

=item * portname

like setting the servicename directly. See <portname|portname> below.

=back

=head3 call

 $soap->call($method, %data);

See above.

call will die if it can't find required elements in the WSDL file or if your data
doesn't meet the WSDL definition's requirements, so you might want to eval{} it.
On death, $@ will (hopefully) contain some error message like

 Error processing WSDL: no <definitions> element found

to give you a hint about what went wrong.

=head2 Configuration methods

=head3 servicename

 $soap->servicename('Service1');

Use this to specify a service by name.
Your wsdl contains definitions for one or more services - hou have to tell
SOAP::WSDL which one to use.

You can call it before each method call.

=head3 portname

 $soap->portname('Port1');

Your service can have one or many ports attached to it.
Each port has some operation defined in it trough a binding.
You have to tell which port of your service should be used for the
method you are calling.

You can call it before each method call.

=head3 wsdl_checkoccurs

Enables/disables checks for correct number of
occurences of elements in WSDL types. The default is 1 (on).

Turning off occurance number checking results in a sligt performance gain.

To turn off checking for correct number of elements, call

 $soap->wsdl_checkoccurs(0);

=head3 wsdl_encoding

The encoding style for the SOAP call.

=head3 cache_directory

enables filesystem caching (in the directory specified). The directory given must be
existant, read- and writeable.

=head3 wsdl_cache_directory

 $soap->wsdl_cache_directory( '/tmp/cache' );

Sets the directory used for filesystem caching and enables filesystem caching.
Passing the I<cache_directory> parameter to wsdlinit has the same effect.

=head2 Seldomly used methods

The following methods are mainly used internally in SOAP::WSDL, but may
be useful for debugging and some special purposes (like forcing a cache flush
on disk or custom cache initializations).

=head3 no_dispatch

Gets/Sets the I<no_dispatch> flag. If no_dispatch is set to true value, SOAP::WSDL
will not dispatch your calls to a remote server but return the SOAP::SOM object
containing the call instead.

=head3 encode

	# this is how call uses encode
	# $xpath contains a XPath object of the wsdl document

	my $def=$xpath->find("/definitions")->shift;
	my $parts=$def->find("//message[\@name='$messageName']/part");

	my @param=();

	while (my $part=$parts->shift) {
		my $enc=$self->encode($part, \%data);
		push @param, $enc if defined $enc;
	}

Does the actual encoding. Expects a XPath::NodeSet as first, a hashref containing
your data as second parameter. The XPath nodeset must be a node specifying a WSDL
message part.

You won't need to call I<encode> unless you plan to
override I<call> or want to write a new SOAP server implementation.

=head3 * wsdl_cache_init

Initialize the WSDL file cache. Normally called from wsdlinit. For custom
cache initailization, you may pass the same parameters as to
Cache::FileCache->new().

=head3 wsdl_cache_store

 $soap->wsdl_cache_store();

Stores the content of the in-memory-cache (and the XML::XPath representation of
the WSDL file) to disk. This will not have any effect if cache_directory is not set.

=head1 Notes

=head2 Why another SOAP module ?

SOAP::Lite provides only some rudimentary WSDL support. This lack is not just
something unimplemented, but an offspring of the SOAP::Schema
class design. SOAP::Schema uses some complicated format to store XML Schema information
(mostly a big hashref, containing arrays of SOAP::Data and a SOAP::Parser-derived
object). This data structure makes it pretty hard to improve SOAP::Lite's
WSDL support.

SOAP::WSDL uses XPath for processing WSDL. XPath is a query language standard for
XML, and usually a good choice for XML transformations or XML template processing
(and what else is WSDL-based en-/decoding ?). Besides, there's an excellent XPath
module (L<XML::XPath>) available from CPAN, and as SOAP::Lite uses XPath to
access elements in SOAP::SOM objects, this seems like a natural choice.

Fiddling the kind of WSDL support implemented here into SOAP::Lite would mean
a larger set of changes, so I decided to build something to use as add-on.

=head2 Memory consumption and performance

SOAP::WSDL uses around twice the memory (or even more) SOAP::Lite uses for the
same task (but remember: SOAP::WSDL does things for you SOAP::Lite can't).
It imposes a slight delay for initialization, and for every SOAP method call, too.

On my 1.4 GHz Pentium mobile notebook, the init delay with a simple
WSDL file (containing just one operation and some complex types and elements)
was around 50 ms, the delay for the first call around 25 ms and for subsequent
calls to the same method around 7 ms without and around 6 ms with XPath result
caching (on caching, see above). XML::XPath must do some caching, too -
don't know where else the speedup should come from.

Calling a method of a more complex WSDL file (defining around 10 methods and
numerous complex types on around 500 lines of XML), the delay for the first
call was around 100 ms for the first and 70 ms for subsequent method calls.
wsdlinit took around 150 ms to process the stuff. With XPath result caching enabled,
all but the first call take around 35 ms.

Using SOAP::WSDL on an idiotically complex WSDL file with just one method, but around
100 parameters for that method, mostly made up by extensions of complex types
(the heaviest XPath operation) takes around 1.2 s for the first call (0.9 with caching)
and around 830 ms for subsequent calls (arount 570 ms with caching).

The actual performance loss compared to SOAP::Lite should be around 10 % less
than the values above - SOAP::Lite encodes the data for you, too (or you do
it yourself) - and encoding in SOAP::WSDL is already covered by the pre-call
delay time mentioned above.

If you have lots of WebService methods and call each of them from time to time,
this delay should not affect your perfomance too much. If you have just one method
and keep calling it ever & ever again, you should cosider hardcoding your data
encoding (maybe even with hardcoded XML templates - yes, this may be a BIG speedup).


=head1 CAVEATS

=head2 API change between 1.20 and 1.21

Giovanni S. Fois has implemented a new calling convention, which allows to specify the
port type used by SOAP::WSDL.

While this allows greater flexibillity (and helps around the still missing bindings support),
the following lines have to be added to existing code:

 $soap->servicename( $servicename);
 $soap->portname( $porttype );

Both lines must appear after calling

 $soap->wsdlinit();

=head2 API change between 1.13 and 1.14

The SOAP::WSDL API changed significantly between versions 1.13 and 1.14.
From 1.14 on, B<call> expects the following arguments: method name as scalar first,
method parameters as hash following.

The B<call> no longer recognizes the I<dispatch> option - to get the same behaviour,
pass C<no_dispatch => 1> to I<new> or call

 $soap->no_dispatch(1);

=head2 Unstable interface

This is alpha software - everything may (and most things will) change.
But you don't have to be afraid too much - at least the I<call> synopsis should
be stable from 1.14 on, and that is the part you'll use most frequently.

=head1 BUGS

=over

=item * Arrays of complex types are not checked for the correct number of elements

Arrays of complex types are just encoded and not checked for correctness etc.
I don't know if I do this right yet, but output looks good. However, they are not
checked for the correct number of element (does the SOAP spec say how to
specify this ?).

=item * +trace (and other SOAP::Lite flags) don't work

This may be an issue with older versions of the base module (before 2.?), or with
activestate's activeperl, which do
not call the base modules I<import> method with the flags supplied to the parent.

There's a simple workaround:

 use SOAP::WSDL;
 import SOAP::Lite +trace;

=item * nothing else known

But I'm sure there are some serious bugs lurking around somewhere.

=back

=head1 TODO

=over

=item Allow use of alternative XPath implementations

XML::XPath is a great module, but it's not a race-winning one.
XML::LibXML offers a promising-looking XPath interface. SOAP::WSDL should
support both, defaulting to the faster one, and leaving the final choice
to the user.

=back

=head1 CHANGES

See CHANGES file.

=head1 COPYRIGHT

This library is free software, you can distribute / modify it under the same
terms as perl itself.

=head1 AUTHOR>

Replace whitespace by '@' in E-Mail addresses.

 Martin Kutter <martin.kutter fen-net.de>
 Giovanni S. Fois <giovannisfois tiscali.it>

=head1 SVN information

 $LastChangedBy: kutterma $
 $HeadURL: https://soap-wsdl.svn.sourceforge.net/svnroot/soap-wsdl/SOAP-WSDL/branches/1.21/lib/SOAP/WSDL.pm $
 $Rev: 20 $

=cut
