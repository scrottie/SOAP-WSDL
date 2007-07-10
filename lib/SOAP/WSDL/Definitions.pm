package SOAP::WSDL::Definitions;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::Base);

my %types_of    :ATTR(:name<types>      :default<[]>);
my %message_of  :ATTR(:name<message>    :default<()>);
my %portType_of :ATTR(:name<portType>   :default<()>);
my %binding_of  :ATTR(:name<binding>    :default<()>);
my %service_of  :ATTR(:name<service>    :default<()>);

my %namespace_of    :ATTR(:name<namespace>      :default<()>);

my %attributes_of :ATTR();

%attributes_of = (
    binding => \%binding_of,
    message => \%message_of,
    portType => \%portType_of,
    service => \%service_of,
);

# Function factory - we could be writing this method for all %attribute
# keys, too, but that's just C&P (eehm, Copy & Paste...)
foreach my $method(keys %attributes_of ) {
    no strict qw/refs/;

    # ... btw, we mean this method here...
    *{ "find_$method" } = sub {
        my ($self, @args) = @_;
        my @found_at = grep {
            $_->get_targetNamespace() eq $args[0] &&
            $_->get_name() eq $args[1]
        }
        @{ $attributes_of{ $method }->{ ident $self } };
        return $found_at[0];
    };
}

sub explain {
	my $self = shift;
	my $opt = shift;
	my $txt = '';
	foreach my $service (@{ $self->get_service() })
	{
		$txt .= $service->explain( $opt );
		$txt .= "\n";
	}
	return $txt;
}

sub to_typemap {
    my $self = shift;
    my $opt = shift;
    $opt->{ prefix } ||= q{};
    $opt->{ wsdl } ||= $self;
    $opt->{ type_prefix } ||= $opt->{ prefix };
    $opt->{ element_prefix } ||= $opt->{ prefix };
    return  join "\n",
        map { $_->to_typemap( $opt ) } @{ $service_of{ ident $self } };
}

1;

=pod

=head1 NAME

SOAP::WSDL::Definitions - model a WSDL E<gt>definitionsE<lt> element

=head1 DESCRIPTION

=head1 METHODS

=head2 first_service get_service set_service push_service

Accessors/Mutators for accessing / setting the E<gt>serviceE<lt> child 
element(s).

=head2 find_service

Returns the service matching the namespace/localname pair passed as arguments.

 my $service = $wsdl->find_service($namespace, $localname);

=head2 first_binding get_binding set_binding push_binding

Accessors/Mutators for accessing / setting the E<gt>bindingE<lt> child 
element(s).

=head2 find_service

Returns the binding matching the namespace/localname pair passed as arguments.

 my $binding = $wsdl->find_binding($namespace, $localname);

=head2 first_portType get_portType set_portType push_portType

Accessors/Mutators for accessing / setting the E<gt>portTypeE<lt> child 
element(s).

=head2 find_portType

Returns the portType matching the namespace/localname pair passed as arguments.

 my $portType = $wsdl->find_portType($namespace, $localname);

=head2 first_message get_message set_message push_message

Accessors/Mutators for accessing / setting the E<gt>messageE<lt> child 
element(s).

=head2 find_service

Returns the message matching the namespace/localname pair passed as arguments.

 my $message = $wsdl->find_message($namespace, $localname);

=head2 first_types get_types set_types push_types

Accessors/Mutators for accessing / setting the E<gt>typesE<lt> child 
element(s).

=head2 explain

Returns a POD string describing how to call the methods of the service(s) 
described in the WSDL. 

=head2 to_typemap

Creates a typemap for use with a generated type class library.

Options:

 NAME            DESCRIPTION
 -------------------------------------------------------------------------
 prefix          Prefix to use for all classes
 type_prefix     Prefix to use for all (Complex/Simple)Type classes
 element_prefix  Prefix to use for all Element classes (with atomic types)

As some webservices tend to use globally unique type definitions, but 
locally unique elements with atomic types, type and element classes may 
be separated by specifying type_prefix and element_prefix instead of 
prefix.

The typemap is plain text which can be used as snipped for building a 
SOAP::WSDL class_resolver perl class.

Try something like this for creating typemap classes: 

 my $parser = XML::LibXML->new();
 my $handler = SOAP::WSDL::SAX::WSDLHandler->new()
 $parser->set_handler( $handler );
 
 $parser->parse_url('file:///path/to/wsdl');

 my $wsdl = $handler->get_data(); 
 my $typemap = $wsdl->to_typemap();

 print <<"EOT"
 package MyTypemap;
 my \%typemap = (
  $typemap
 );
 sub get_class { return \$typemap{\$_[1] } };
 1;
 "EOT"

=head1 LICENSE

Copyright 2004-2007 Martin Kutter.

This file is part of SOAP-WSDL. You may distribute/modify it under 
the same terms as perl itself

=head1 AUTHOR

Martin Kutter E<lt>martin.kutter fen-net.deE<gt>

=cut

