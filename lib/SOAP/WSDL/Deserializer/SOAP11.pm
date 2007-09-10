package SOAP::WSDL::Deserializer::SOAP11;
use strict;
use warnings;
use Class::Std::Storable;
use SOAP::WSDL::SOAP::Typelib::Fault11;

our $VERSION='2.00_13';

my %class_resolver_of :ATTR(:name<class_resolver> :default<()>);

sub BUILD {
    my ($self, $ident, $args_of_ref) = @_;
    
    # ignore all options except 'class_resolver'
    for (keys %{ $args_of_ref }) {
        delete $args_of_ref->{ $_ } if $_ ne 'class_resolver';
    }

}


sub deserialize {
    my ($self, $content) = @_;
        
    my $parser = SOAP::WSDL::Expat::MessageParser->new({
        class_resolver => $class_resolver_of{ ident $self },
    });
    eval { $parser->parse_string( $content ) };
    if ($@) {
        return $self->generate_fault({
            code => 'soap:Server',
            role => 'urn:localhost',
            message => "Error deserializing message: $@. \n"
                . "Message was: \n$content"
        });
    }
    return $parser->get_data();
}

sub generate_fault {
    my ($self, $args_from_ref) = @_;
    return SOAP::WSDL::SOAP::Typelib::Fault11->new({
            faultcode => $args_from_ref->{ code } || 'soap:Client',
            faultactor => $args_from_ref->{ role } || 'urn:localhost',
            faultstring => $args_from_ref->{ message } || "Unknown error"
    }); 
}

1;