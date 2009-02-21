package CodeFirst;
use strict;
use warnings;
use Carp;
use Class::Std::Fast::Storable;
use Scalar::Util qw(blessed);

our $VERSION = 0.1;

$Carp::Internal{attributes}++;

my %ACTION_MAP_OF;

my %transport_class_of :ATTR(:name<transport_class> :default<SOAP::WSDL::Server::CGI>);
my %transport_of : ATTR(:name<transport> :default<()>);
my %dispatch_to : ATTR(:name<dispatch_to> :default<()>);

sub START {
    my ( $self, $ident, $arg_ref ) = @_;
    my $class = ref $self;
    eval "require $transport_class_of{ $ident }"
      or die "Cannot load transport class $transport_class_of{ $ident }: $@";
    $transport_of{$ident} = $transport_class_of{$ident}->new( {
            action_map_ref => $ACTION_MAP_OF{$class},
            dispatch_to    => $self
    } );
}

sub handle {
    $transport_of{${$_[0]}}->handle( @_[1 .. $#_] );
}

sub _action_map {
    my $class = ref $_[0];
    return $ACTION_MAP_OF{$class};
}

no warnings qw(redefine);

sub MODIFY_CODE_ATTRIBUTES {
    my ( $class, $code, @attribute_from ) = @_;

    my ($content) = grep { $_ =~ m{^WebMethod}xms } @attribute_from
      or return @attribute_from;

    $content =~ s{^WebMethod}{}xms;
    my %parameter_of = eval $content;
    if ($@) {
        die "Cannot parse :WebMethod arguments: $@ at " . Carp::shortmess;
    }

    $ACTION_MAP_OF{$class}->{$parameter_of{action}} = $code;

    # print Dumper \%ACTION_MAP_OF;

    return Class::Std::Fast::MODIFY_CODE_ATTRIBUTES( $class, $code,
        @attribute_from );

}

1;

1;
