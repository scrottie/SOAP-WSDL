#!/usr/bin/perl -w
package SOAP::WSDL;

use SOAP::Lite;
use vars qw($VERSION @ISA);
use XML::XPath;	
use Cache::FileCache;

use Data::Dumper;
# use Carp;
use diagnostics;

@ISA= qw(SOAP::Lite);

# let CVS handle this for you...
$VERSION = sprintf("%d.%02d", q$Revision: 1.17 $ =~ /(\d+)\.(\d+)/);

sub wsdlinit {
	my $self=shift;
	my %opt=@_;
	$self->{_WSDL}->{ cache } = {};
	$self->{_WSDL}->{ caching } = $opt{ caching };
	$self->{_WSDL}->{ cache_directory } = $opt{ cache_directory } if exists($opt{cache_directory});
	$self->{_WSDL}->{ checkoccurs } = 1 unless defined(	$self->{_WSDL}->{ checkoccurs } );

	if (($self->{_WSDL}->{ caching }) && (! $self->{_WSDL }->{ fileCache })) {
		$self->wsdl_cache_init() 
	};
	
	my $location=$self->transport->proxy->endpoint
		|| die "Error processing WSDL: No port specified. ".
			"You need to call port() before calling wsdlinit";
	
	# makeup xpath document
	my $xpath;
	# check cache 
	if ($self->{_WSDL}->{ fileCache }) {
		# get xpath from cache
		$xpath =  $self->{_WSDL}->{ fileCache }->get( $self->wsdl );
		# get in-memory cache from cache
		if ($self->{_WSDL}->{ caching }) {
			my $cache=$self->{_WSDL}->{ fileCache }->get( $self->wsdl."_cache" );
			$self->{_WSDL}->{ cache } = $cache || {};
		}
	} 
	unless ($xpath) {
		$xpath = XML::XPath->new( 
			xml => SOAP::Schema->new(schema => $self->wsdl)->access );
	}

	($xpath) || 
		die "Error processing WSDL: Cannot create XPath object";

	# Get root element (<definitions>) and get 
	# default prefix (the root element's one).
	my $definitions=undef;
	$definitions=$xpath->find('/*[1]')->shift;
	my $prefix= $definitions->getPrefix;
	$self->_wsdl_wsdlns( $prefix ? $prefix.':' : '' );

	# get targetNamespace
	my $tns= $definitions->getAttribute('targetNamespace')
			|| die "Error processing WSDL: cannot get <definition targetNamespace=''>";

	# look for schema namespace & prefix for targetNamespace
	my ($defaultNS, $schemaNS) = ('','');
	my @_ns_sub_list=();
	
	my $nameSpaces=$definitions->getNamespaces 
		|| die "Error processing WSDL: cannot get <definition> namespaces";
	my $nsHash={};
	foreach my $ns( @{ $nameSpaces } ) {
		$xpath->set_namespace($ns->getPrefix, $ns->getData);
		if ($ns->getData eq $tns) {
			push @_ns_sub_list, $ns->getPrefix;
			next;
		}
		if ($ns->getData eq 'http://www.w3.org/2001/XMLSchema') {
			$schemaNS=$ns->getPrefix;
		}
		$nsHash->{ $ns->getData } = $ns->getPrefix.':';
	}
	$self->_wsdl_ns( $nsHash );
	
	$defaultNS=join('|', @_ns_sub_list);
	$self->_wsdl_tns($defaultNS);
	$self->_wsdl_tns_uri($tns);
	$self->_wsdl_schemans($schemaNS);
	
	
	### TBD: get portName with ONE xpath expression (yup this IS possible).
	
	# find address in service ports
	my $path=$self->servicename ? "[\@name='". $self->servicename ."']" : '';

	$path="/".$self->_wsdl_wsdlns."definitions/"
		.$self->_wsdl_wsdlns."service$path/"
		.$self->_wsdl_wsdlns."port/"
		.$self->_wsdl_ns->{'http://schemas.xmlsoap.org/wsdl/soap/'} 
		."address[\@location='$location']";

	my $service=$xpath->find($path)
		# get 1st matching node -> get parent node -> get value of "name"
		->shift || die "Error processing WSDL file - no such service ($path)";
	my $portName=$service->getParentNode->findvalue('@name') 
			|| die "Error processing WSDL: Cannot find ".
				"port for location $location in service $path";
	
	$self->_wsdl_portname($portName);
	$self->_wsdl_xpath( $xpath );
}

sub call {
	my $self=shift;
	my $method=shift;
	my %data=@_;

	my $path;

	my $location=$self->endpoint;

	my $mode='input';

	my $tns=$self->_wsdl_tns;
	my $ns=$self->_wsdl_ns;
	### get input|output message

	my $xpath=$self->_wsdl_xpath;
	
	($xpath) || do {
		$self->wsdlinit;
		$xpath=$self->_wsdl_xpath || die "Error processing WSDL: no wsdl object";
	};
	### jump to nodeset matching operation & take the first one (there is only one)
	my $portName=$self->_wsdl_portname || die "Error processing WSDL: no port name";
	
	$path='/' . $self->_wsdl_wsdlns . 'definitions/'
		.$self->_wsdl_wsdlns . "portType[\@name='$portName']/"
		.$self->_wsdl_wsdlns . "operation[\@name='$method']/"
		.$self->_wsdl_wsdlns ."$mode/\@message";

	# try cache first if caching is enabled
	my $messageName=$self->{_WSDL}->{ caching } ? $self->{_WSDL}->{ cache }->{ $path } : undef;

	unless ($messageName) {
		$messageName=$xpath->findvalue($path)
			|| die "Error processing WSDL: cannot find $mode message for method '$method' ($path)";
		$self->{_WSDL}->{ cache }->{ $path }= $messageName if ($self->{_WSDL}->{ caching });
	}
	
	# remove default targetNamespace from messageName
	$messageName=~s/^($tns)\:*//;
	
	$path='/' . $self->_wsdl_wsdlns . 'definitions/'
		. $self->_wsdl_wsdlns . "message[\@name='$messageName']/"
		. $self->_wsdl_wsdlns . 'part';

	# try cache first, if caching is enabled
	my $parts=$self->{_WSDL}->{ caching } ? $self->{_WSDL}->{ cache }->{ $path } : undef;
	unless ($parts) {
		$parts= $xpath->find($path);
		$self->{_WSDL}->{ cache }->{ $path }= $parts if ($self->{_WSDL}->{ caching });
	}

	($parts) || die "Error processing WSDL: No parts found for message $messageName with path '$path'";

	my @param=();

	while (my $part=$parts->shift) {
		my @enc=$self->encode($part, \%data); 
		push @param, @enc if (@enc);
	}

	### TBD: encode method (fully qualified)
	my $methodEncoded=SOAP::Data->name( $method )->attr( { xmlns => $self->_wsdl_tns_uri } );
	
	unless ($self->{_WSDL}->{no_dispatch}) { 
		return $self->SUPER::call($methodEncoded => @param);	
	} else {
		return $methodEncoded, @param;
	}
}

sub DESTROY {
	my $self=shift;
	$self->wsdl_cache_store();
	return 1;
}

sub no_dispatch {
	my $self = shift;
	return (@_) ? $self->{_WSDL}->{no_dispatch}=shift : $self->{_WSDL}->{no_dispatch};
}

sub wsdl {
	my $self = shift;
	return (@_) ? $self->{_WSDL}->{wsdl}=shift : $self->{_WSDL}->{wsdl};
}

sub wsdl_checkoccurs {
	my $self = shift;
	return (@_) ? $self->{_WSDL}->{ checkoccurs }=shift : $self->{_WSDL}->{ checkoccurs };
}


sub servicename {
	my $self = shift;
	return (@_) ? $self->{_WSDL}->{servicename}=shift : $self->{_WSDL}->{servicename};
}

sub wsdl_cache_directory {
	my $self = shift;
	return (@_) ? $self->{_WSDL}->{ cache_directory }=shift : $self->{_WSDL}->{ cache_directory };
}

sub wsdl_cache_store {
	my $self=shift;
	if ( ( $self->{ _WSDL }->{ cache_directory }) && ($self->{ _WSDL }->{ fileCache } ) ) {
		$self->{ _WSDL }->{ fileCache }->set( $self->wsdl, $self->{ _WSDL }->{ xpath } );
		$self->{ _WSDL }->{ fileCache }->set( $self->wsdl."_cache", $self->{ _WSDL }->{ cache } );
	}
}

sub wsdl_cache_init {
	my $self=shift;
	my $p=shift || undef;
	my $cache = undef;
	if ( defined( $p ) ) {
		$p->{ cache_root } = $self->{_WSDL}->{ cache_directory } unless ($p->{ cache_root });
		$cache=Cache::FileCache->new( $p ) if ($p->{ cache_root });
	} else {
		$cache=Cache::FileCache->new( { cache_root => $self->{_WSDL}->{ cache_directory } } ) if ($self->{_WSDL}->{ cache_directory });
	}
	$self->{_WSDL}->{ fileCache } = $cache;
}

sub _wsdl_ns {
	my $self = shift;
	return (@_) ? $self->{_WSDL}->{namespaces}=shift : $self->{_WSDL}->{namespaces};
}

sub _wsdl_xpath {
	my $self = shift;
	return (@_) ? $self->{_WSDL}->{xpath}=shift : $self->{_WSDL}->{xpath};
}

sub _wsdl_tns{
	my $self = shift;
	return (@_) ? $self->{_WSDL}->{tns}=shift : $self->{_WSDL}->{tns};
}

sub _wsdl_tns_uri{
	my $self = shift;
	return (@_) ? $self->{_WSDL}->{tns}->{uri}=shift : $self->{_WSDL}->{tns}->{uri};
}

sub _wsdl_wsdlns{
	my $self = shift;
	return (@_) ? $self->{_WSDL}->{wsdlns}=shift : $self->{_WSDL}->{wsdlns};
}

sub _wsdl_schemans{
	my $self = shift;
	return (@_) ? $self->{_WSDL}->{schemans}=shift : $self->{_WSDL}->{schemans};
}

sub _wsdl_portname{
	my $self = shift;
	return (@_) ? $self->{_WSDL}->{portname}=shift : $self->{_WSDL}->{portname};
}

sub encode {
	my $self=shift;
	my $part=shift;
	my $data=shift;

	my $schemaNS=$self->{_WSDL}->{schemans};
	my $defaultNS=$self->{_WSDL}->{tns};

	my %nsHash = reverse %{ $self->_wsdl_ns };
	my %nsURIs = %{ $self->_wsdl_ns };

# 	print Dumper %nsHash;

	# TBD: Caching hook ? 

	my 	$p=	{
		name => $part->findvalue('@name')->value,
		type => $part->findvalue('@type')->value,
		element => $part->findvalue('@element')->value,
		xmlns => $part->findvalue('@targetNamespace')->value,
		nillable => $part->findvalue('@nillable')->value,
		};
	
	my $result=undef;
	my $order=undef;
	
	if ( ($p->{type}) ) {
		#
		# it's either a XML schema type or an apache-soap type
		my $match;
		{ 
			no warnings;
			$match="$nsURIs{'http://www.w3.org/2001/XMLSchema'}|$nsURIs{'http://xml.apache.org/xml-soap'}";
			$match=~s/\|$//;
		};
		
		if ( $p->{type}=~m/^$match/ )
		{		### simple type
			my $count=-1;
			if ($self->{_WSDL}->{checkoccurs}) {
				$count= exists $data->{ $p->{ name } } ? 
					defined $data->{ $p->{ name } } ?
						ref $data->{ $p->{ name } } eq 'ARRAY' ? 
							scalar @{ $data->{ $p->{ name } } } 
							: 1 
						: 0
					: 0 ;
				
				$order=$part->getParentNode()->getName;
		
				$p->{ minOccurs }=$part->findvalue('@minOccurs')->value;
				if ( (! defined($p->{ minOccurs }) ) || ( $p->{ minOccurs } eq "") ) {
					if ($order eq 'sequence') { $p->{ minOccurs }=1 }
					elsif ($order eq 'all') { $p->{ minOccurs }=0  }
					else { $p->{ minOccurs }=0 }
				}
				$p->{ maxOccurs }=$part->findvalue('@maxOccurs')->value;
				if ( (! defined($p->{ maxOccurs }) ) || ($p->{ maxOccurs } eq "") ) {
					if ($order eq 'sequence') { $p->{ maxOccurs }=1 }
					elsif  ($order eq 'all') { $p->{ maxOccurs }=1  }
					else { $p->{ maxOccurs }=undef }
				}
				$p->{ maxOccurs } = undef if (defined($p->{ maxOccurs }) &&  $p->{ maxOccurs } eq 'unbounded' );
			}

			# check for ocurrence ?
			# acceptable number of value ?
			if (   (! $self->{_WSDL}->{checkoccurs} )
				|| ( ( $p->{ minOccurs } <=$count ) || ($p->{ nillable } eq "true") )
					&& (  ( !defined($p->{ maxOccurs }) ) || ($count <= $p->{ maxOccurs })  )   ) {
				# not nillable
				# empty value
				( ! $p->{ nillable } ) &&
				(  ( ! (exists $data->{ $p->{ name } }) ) || (! (defined $data->{ $p->{ name } }) )  ) 
					&& do {
						return ();
					};
				# some value
				
				# SOAP::Lite uses the "xsd" prefix for specifying schema NS
				my $type=$p->{ type };
				$type=~s/^$schemaNS/xsd/;
				$result=SOAP::Data->new( name => $p->{ name } );
				$result->type( $type ) if ($self->autotype);
				$result->attr( { xmlns => $p->{ xmlns } } ) if $p->{ xmlns };
				return ($result->value( $data->{  $p->{ name }  } ) );
			} else {
				no warnings;
				die "illegal number of elements ($count, min: ".$p->{ minOccurs } .", max: .".$p->{ maxOccurs }.") for element '$p->{ name }' (may be sub-element) ";
			}

		} else { ### complex type					
			### get complex type
			my $name=$p->{ type };
			$name=~s/^$defaultNS\://;

			$name=~s/^(.+?\:)?//;
			my $path;
			{ 
				no warnings;
			
				$path='/'.$self->_wsdl_wsdlns.'definitions/'
					.$self->_wsdl_wsdlns."types/$schemaNS:schema/"
					."$schemaNS:complexType[\@name='$name']"
					.'|'
					.'/'.$self->_wsdl_wsdlns.'definitions/'
					.$self->_wsdl_wsdlns."types/schema[\@xmlns='". $nsHash{$schemaNS.':'} ."' and \@targetNameSpace = '". $nsHash{$1}."' ]/"
					."complexType[\@name='$name']"
					;
			};
			# got an absolute path - try cache first
			my $complexType=$self->{_WSDL}->{ caching } ? $self->{_WSDL}->{ cache }->{ $path } : undef;
			unless ($complexType) {
				$complexType=$self->{_WSDL}->{xpath}->find($path)->shift 
					|| die "Error processing WSDL: $path not found";
				$self->{_WSDL}->{ cache }->{ $path } = $complexType if ($self->{_WSDL}->{ caching });
			}

			# handle arrays of complex types
			### TBD: check for min /max number of elements
			if (ref $data->{ $p->{ name } } eq 'ARRAY') {
				my @resultArray=();
				foreach my $subdata( @{ $data->{ $p->{ name } } }) {
					$result=SOAP::Data->new( name => $p->{ name } );
					$result->type( $type ) if ($self->autotype);
					$result->attr( { xmlns => $p->{ xmlns } } ) if $p->{ xmlns };
					my $value = $self->encodeComplexType($complexType, $subdata );
					push @resultArray, $result->value( $value ) if (defined($value) );		
				}
				return (@resultArray) ? @resultArray : ();
			} else {
				$result=SOAP::Data->new( name => $p->{ name } );
				$result->type( $type ) if ($self->autotype);
				$result->attr( { xmlns => $p->{ xmlns } } ) if $p->{ xmlns };
				
				my $value;
				 $value = $self->encodeComplexType($complexType, $data->{ $p->{ name } } ) ;
#					|| die "error encoding ". $p->{ name } .": \n\t $@";
				return () unless ( defined($value) );
				return ($result->value( $value));
			}
		}
	} elsif ($p->{ element } ) {
		### get element	
		my $elementPath=$p->{element};
		$elementPath=~s/^$defaultNS\://;
		
		my $path= '/'.$self->_wsdl_wsdlns.'definitions/'
			.$self->_wsdl_wsdlns.'types/'
			.$schemaNS.':schema/'
			.$schemaNS.':element[@name="'.$elementPath.'"]/'
			.$schemaNS.':complexType/'
			.'descendant::'.$schemaNS.':element'
			;

		# got an absolute path - try cache first
		my $elements = $self->{_WSDL}->{caching } ? $self->{_WSDL}->{cache}->{$path} : undef;
		unless ($elements) {
			$elements=$self->{_WSDL}->{xpath}->findnodes($path)
				|| die "Error processing WSDL: '$path' not found";
			$self->{_WSDL}->{cache}->{$path}= $elements if ($self->{_WSDL}->{caching});
		}

		my @resultArray=();
		while (my $e=$elements->shift) {
			my @enc;
			@enc=$self->encode($e, $data);
			# die "error encoding ". $p->{ name } .": \n\t$@";
			push @resultArray, @enc if (@enc);
		}	
		return (@resultArray) ? @resultArray : ();
	} else {
		die "illegal part definition\n";
	}
	return (); 	# if we got here, something went wrong...
}

sub encodeComplexType {
	my $self=shift;
	my $complexType=shift;
	my $data = shift;
	my @result = ();
	my $schemaNS=$self->_wsdl_schemans ? $self->_wsdl_schemans .':' : '';
	my $defaultNS=$self->_wsdl_tns;
	my %nsHash = reverse %{ $self->_wsdl_ns };
	#######################################################################
	# TBD: handle restriction here
	#######################################################################
	### check for extension
	my $extension=$complexType->find('.//'.$schemaNS.'extension')->shift;
	if ($extension) {
		### pull in extension base
		my $base=$extension->findvalue('@base');
		$base=~s/^$defaultNS\://;
		$base=~s/^(.+?\:)//;
		my $path;
		{ no warnings;
			# there are two ways how schema are usually defined
			$path='/'.$self->_wsdl_wsdlns.'definitions/'
				.$self->_wsdl_wsdlns."types/".$schemaNS."schema/"
				.$schemaNS."complexType[\@name='$base']/descendant::".$schemaNS."element"
				.'|'
				.'/'.$self->_wsdl_wsdlns.'definitions/'
				.$self->_wsdl_wsdlns."types/schema[\@xmlns='". $nsHash{$schemaNS} ."' and \@targetNameSpace = '". $nsHash{$1}."' ]/"
				."complexType[\@name='$base']/descendant::element";
		};

		# got an absolute path - try cache first
		my $elements=$self->{_WSDL}->{ caching } ? $self->{_WSDL}->{ cache }->{ $path } : undef;
		
		unless ($elements) {
			$elements=$self->{_WSDL}->{xpath}->find($path)
				|| die "Error processing WSDL: '$path' not found";
			# set cache
			$self->{_WSDL}->{ cache }->{ $path } = $elements if ($self->{_WSDL}->{ caching });
		};

		while (my $e=$elements->shift) {
			my @enc;
			@enc=$self->encode($e, $data);
			push @result, @enc if (@enc);
		}	
	}
	my $path='.//'.$schemaNS.'element';
	my $elements=$complexType->find($path) 
			|| die "Error processing WSDL: './/".$schemaNS."element' not found";

	while (my $e=$elements->shift) {
			my @enc;
			@enc=$self->encode($e, $data); #			|| die "$@";
		push @result, @enc if (@enc);
	}
	return (@result) ? \SOAP::Data->value(@result) : ();
}

1;


__END__

=pod

=head1 NAME

SOAP::WSDL

=head1 SYNOPSIS

 use SOAP::WSDL;
 
 my $soap=SOAP::WSDL->new( wsdl => 'http://server.com/ws.wsdl' )
    ->proxy( 'http://myurl.com');
    
 $soap->wsdlinit;
   
 my $som=$soap->call( 'method' => [ 
                  { name => value },
                  { name => 'value' } ]);


=head1 DESCRIPTION

SOAP::WSDL provides decent WSDL support for SOAP::Lite. It is built as a 
add-on to SOAP::Lite, and will sit on top of it, forwarding all 
 the actual request-response to SOAP::Lite - somewhat like a pre-processor.

WSDL support means that you don't have to deal with those bitchy namespaces 
some web services set on each and every method call parameter. 

It also means an end to that nasty 

 SOAP::Data->name( 'Name' )->value(
    SOAP::Data->name( 'Sub-Name')->value( 'Subvalue' )
 );

encoding of complex data. (Another solution for this problem is just iterating 
recursively over your data. But that doesn't work if you need more information 
[e.g. namespaces etc] than just your data to encode your parameters).

And it means that you can use ordinary hashes for your parameters - the encording 
order will be derived from the WSDL and not from your (unordered) data, thus the 
problem of unordered  perl-hashes and WSDL E<gt>sequenceE<lt> definitions is 
solved, too. (Another solution for the ordering problem is tying your hash to a 
class that provides ordered hashes - Tie::IxHash is one of them).

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
 
 # you must call proxy before you call wsdlinit
 $soap->proxy( 'http://myurl.com')

 # optional (only necessary if the service you use is not the first one 
 # in document order in the WSDL file).
 # If used, it must be called before wsdlinit.
 $soap->servicename('Service1');
 
 # optional, set to a false value if you don't want your 
 # soap message elements to be typed
 $soap->autotype(0);
 
 # never forget to call this !
 $soap->wsdlinit;
 
 # with caching enabled:
 $soap->wsdlinit( caching => 1);
   
 my $som=$soap->call( 'method' ,  
                   name => 'value' ,
                   name => 'value'  );
 

=head1 How it works 

SOAP::WSDL takes the wsdl file specified and looks up the port for the service. 
On calling a SOAP method, it looks up the message encoding and wraps all the 
stuff around your data accordingly.

Most pre-processing is done in I<wsdlinit>, the rest is done in I<call>, which 
overrides the same method from SOAP::Lite.

=head2 wsdlinit

SOAP::WSDL loads the wsdl file specified by the wsdl parameter / call using 
SOAP::Lite's schema method. It sets up a XPath object of that wsdl file, and 
subsequently queries it for namespaces, service, and port elements.

The port you are using is deduced from the URL you're going to 
connect to. SOAP::WSDL uses the first service (in document order) specified 
in the wsdl file. If you want to chose a different one, you can specify 
the service by calling

 $soap->servicename('ServiceToUse');

If you want to specify a service name, do it before calling I<wsdlinit> - it 
has no effect afterwards.

=head2 call

The call method examines the wsdl file to find out how to encode the SOAP 
message for your method. Lookups are done in real-time using XPath, so this 
incorporates a small delay to your calls (see L</Memory consumption and performance> 
below.

The SOAP message will include the types for each element, unless you have 
set autotype to a false value by calling 

 $soap->autotype(0);

After wrapping your call into what is appropriate, SOAP::WSDL uses the I<call()> 
method from SOAP::Lite to dispatch your call.

call takes the method name as first argument, and the parameters passed to that 
method as following arguments.

B<Example:>

 $som=$soap->call( "SomeMethod" => "test" => "testvalue" );
   
 $som=$soap->call( "SomeMethod" => %args );

=head1 Caching

SOAP::WSDL uses a two-stage caching mechanism to achieve best performance. 

First, there's a pretty simple caching mechanisms for storing XPath query results.
They are just stored in a hash with the XPath path as key (until recently, only 
results of "find" or "findnodes" are cached). I did not use the obvious 
L<Cache|Cache> or L<Cache::Cache|Cache::Cache>  module here, because these use L<Storable|Storable> to 
store complex objects and thus incorporate a performance loss heavier than using 
no cache at all.
Second, the XPath object and the XPath results cache are be stored on disk using 
the L<Cache::FileCache|Cache::FileCache> implementation. 

A filesystem cache is only used if you 

 1) enable caching
 2) set wsdl_cache_directory 

The cache directory must be, of course, read- and writeable.

XPath result caching doubles performance, but increases memory consumption - if you lack of 
memory, you should not enable caching (disabled by default).

Filesystem caching triples performance for wsdlinit and doubles performance for the first 
method call.

The file system cache is written to disk when the SOAP::WSDL object is destroyed. 
It may be written to disk any time by calling the L</wsdl_cache_store> method

Using both filesystem and in-memory caching is recommended for best performance and 
smallest startup costs.

=head2 Sharing cache between applications

Sharing a file system cache among applications accessing the same web service is 
generally possible, but may under some circumstances reduce performance, and under 
some special circumstances even lead to errors. 
This is due to the cache key algorithm used.

SOAP::WSDL uses the SOAP endpoint URL to store the XML::XPath object of the wsdl file.
In the rare case of a web service listening on one particular endpoint (URL) but using 
more than one WSDL definition, this may lead to errors when applications using 
SOAP::WSDL share a file system cache.

SOAP::WSDL stores the XPath results in-memory-cache in the filesystem cache, using the 
key of the wsdl file with C<_cache> appended. Two applications sharing the file system 
cache and accessing different methods of one web service could overwrite each others 
in-memory-caches when dumping the XPath results to disk, resulting in a slight performance 
drawback (even though this only happens in the rare case of one app being started before 
the other one has had a chance to write its cache to disk).

=head2 Controlling the file system cache

If you want full controll over the file system cache, you can use wsdl_init_cash to 
initialize it. wsdl_init_cash will take the same parameters as Cache::FileCache->new().
See L<Cache::Cache> and L<Cache::FileCache> for details.

=head2 Notes

If you plan to write your own caching implementation, you should consider the following:

The XPath results cache must not survive the XPath object SOAP::WSDL uses to 
store the WSDL file in (this could cause memory holes - see L<XPath|XPath> for details).
This never happens during normal usage - but note that you have been warned 
before trying to store and re-read SOAP::WSDL's internal cache.

=head1 Methods

=over 4

=item call

 $soap->call($method, %data);

See above.

call will die if it can't find required elements in the WSDL file or if your data 
doesn't meet the WSDL definition's requirements, so you might want to eval{} it. 
On death, $@ will (hopefully) contain some error message like 

 Error processing WSDL: no <definitions> element found

to give you a hint about what went wrong.

=item no_dispatch

Gets/Sets the I<no_dispatch> flag. If no_dispatch is set to true value, SOAP::WSDL 
will not dispatch your calls to a remote server but return the SOAP::SOM object 
containing the call instead.

Useful for testing / debugging

=item encode

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

=item servicename

 $soap->servicename('Service1');

Use this to specify a service by name (if none specified, the first one in document 
order from the WSDL file is used). You must call this before calling L</wsdlinit>.

=item wsdl

 $soap->wsdl('http://my.web.service.com/wsdl');

Use this to specify the WSDL file to use. Must be a valid (and accessible !) url.
You must call this before calling L</wsdlinit>.

For time saving's sake, this should be a local file - you never know how much 
time your WebService needs for delivering a wsdl file.

=item wsdlinit

 $soap->wsdlinit( caching => 1, 
 	cache_directory => '/tmp/cache' );

Initializes the WSDL document for usage and looks up the web service and port to use
(the port is derived by the URL specified via SOAP::Lite's I<proxy> method).

wsdlinit will die if it can't set up the WSDL file properly, so you might want to 
eval{} it.

On death, $@ will (hopefully) contain some error message like 

 Error processing WSDL: no <definitions> element found

to give you a hint about what went wrong.

wsdlinit will accept a hash of parameters with the following keys:

=over 8

=item * caching

enables caching is set to a true value

=item * cache_directory

enables filesystem caching (in the directory specified). The directory given must be
existant, read- and writeable.

=back

=item wsdl_cache_directory 

 $soap->wsdl_cache_directory( '/tmp/cache' );

Sets the directory used for filesystem caching and enables filesystem caching.
Passing the I<cache_directory> parameter to wsdlinit has the same effect.

=item wsdl_cache_store

 $soap->wsdl_cache_store();

Stores the content of the in-memory-cache (and the XML::XPath representation of 
the WSDL file) to disk. This will not have any effect if cache_directory is not set.

=back

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
calls to the same method around 7 ms without and around 6 ms with XPath result caching 
(on caching, see above). XML::XPath must do some caching, too - don't know where 
else the speedup should come from.

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

=head1 LIMITATIONS

=over

=item * E<lt>restrictionE<gt>

SOAP::WSDL doesn't handle C<restriction> WSDL elements yet.

=item * bindings

SOAP::WSDL does not care about port bindings yet.

=item * overloading

WSDL overloading is not supported yet. 

=back

=head1 CAVEATS

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

=item Implement bindings support

WSDL bindings are required for SOAP authentication. This is not too 
hard to implement - just look up bindings and decide for each 
(top level) element whether to put it into header or body.

=item Allow use of alternative XPath implementations

XML::XPath is a great module, but it's not a race-winning one. 
XML::LibXML offers a promising-looking XPath interface. SOAP::WSDL should 
support both, defaulting to the faster one, and leaving the final choice 
to the user.

=back

=head1 CHANGES

$Log: WSDL.pm,v $
Revision 1.17  2004/07/05 08:19:49  lsc
- added wsdl_checkoccurs

Revision 1.16  2004/07/04 09:01:14  lsc
- change <definitions> element lookup from find('/definitions') and find('wsdl:definitions') to find('/*[1]') to process arbitrary default (wsdl) namespaces correctly
- fixed test output in test 06

Revision 1.15  2004/07/02 12:28:31  lsc
- documentation update
- cosmetics

Revision 1.14  2004/07/02 10:53:36  lsc
- API change:
    - call now behaves (almost)  like SOAP::Lite::call
    - call() takes a list (hash) as second argument
    - call does no longer support the "dispatch" option
    - dispatching calls can be suppressed by passing
         "no_dispatch => 1" to new()
    - dispatching calls can be suppressed by calling
           $soap->no_dispatch(1);
       and re-enabled by calling
           $soap->no_dispatch(0);
- Updated test skripts to reflect API change.

Revision 1.13  2004/06/30 12:08:40  lsc
- added IServiceInstance (ecmed) to acceptance tests
- refined documentation

Revision 1.12  2004/06/26 14:13:29  lsc
- refined file caching
- added descriptive output to test scripts

Revision 1.11  2004/06/26 07:55:40  lsc
- fixed "freeze" caching bug
- improved test scripts to test file system caching (and show the difference)

Revision 1.10  2004/06/26 06:30:33  lsc
- added filesystem caching using Cache::FileCache

Revision 1.9  2004/06/24 12:27:23  lsc
Cleanup

Revision 1.8  2004/06/11 19:49:15  lsc
- moved .t files to more self-describing names
- changed WSDL.pm to accept AXIS wsdl files
- implemented XPath query result caching on all absolute queries

Revision 1.7  2004/06/07 13:01:16  lsc
added changelog to pod


=head1 COPYRIGHT

(c) 2004 Martin Kutter

This library is free software, you can use it under the same 
terms as perl itself.

=head1 AUTHOR

Martin Kutter <martin.kutter@fen-net.de>

=cut
