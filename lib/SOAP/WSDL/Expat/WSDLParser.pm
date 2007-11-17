package SOAP::WSDL::Expat::WSDLParser;
use strict;
use warnings;
use Carp;
use SOAP::WSDL::TypeLookup;
use base qw(SOAP::WSDL::Expat::Base);

sub _initialize {
    my ($self, $parser) = @_;

    # init object data
    $self->{ parser } = $parser;
    delete $self->{ data };

    # setup local variables for keeping temp data
    my $characters = undef;
    my $current = undef;
    my $list = [];        # node list

    # TODO skip non-XML Schema namespace tags
    $parser->setHandlers(
        Start => sub {
            my ($parser, $localname, %attrs) = @_;
            $characters = q{};

            my $action = SOAP::WSDL::TypeLookup->lookup(
                $parser->namespace($localname),
                $localname
            );

            return if not $action;

            if ($action->{ type } eq 'CLASS') {
                eval "require $action->{ class }";
                croak $@ if ($@);

                my $obj = $action->{ class }->new({ parent => $current })
                  ->init( _fixup_attrs( $parser, %attrs ) );

                if ($current) {
                    # inherit namespace, but don't override
                    $obj->set_targetNamespace( $current->get_targetNamespace() )
                        if not $obj->get_targetNamespace();

                    # push on parent's element/type list
                    my $method = "push_$localname";

                    no strict qw(refs);
                    $current->$method( $obj );

                    # remember element for stepping back
                    push @{ $list }, $current;
                }
                else {
                    $self->{ data } = $obj;
                }
                # set new element (step down)
                $current = $obj;
            }
            elsif ($action->{ type } eq 'PARENT') {
                $current->init( _fixup_attrs($parser, %attrs) );
            }
            elsif ($action->{ type } eq 'METHOD') {
                my $method = $action->{ method } || $localname;

                no strict qw(refs);
                # call method with
                # - default value ($action->{ value } if defined,
                #   dereferencing lists
                # - the values of the elements Attributes hash
                # TODO: add namespaces declared to attributes.
                # Expat consumes them, so we have to re-add them here.
                $current->$method( defined $action->{ value }
                    ? ref $action->{ value }
                        ? @{ $action->{ value } }
                        : ($action->{ value })
                    : _fixup_attrs($parser, %attrs)
                );
            }

            return;
        },

        Char => sub { $characters .= $_[1]; return;  },

        End => sub {
            my ($parser, $localname) = @_;

            my $action = SOAP::WSDL::TypeLookup->lookup(
                $parser->namespace( $localname ),
                $localname
            ) || {};

            return if not ($action->{ type });
            if ( $action->{ type } eq 'CLASS' ) {
               $current = pop @{ $list };
            }
            elsif ($action->{ type } eq 'CONTENT' ) {
                my $method = $action->{ method };

                # normalize whitespace
                $characters =~s{ ^ \s+ (.+) \s+ $ }{$1}xms;
                $characters =~s{ \s+ }{ }xmsg;

                no strict qw(refs);
                $current->$method( $characters );
            }
            return;
        }
    );
    return $parser;
}

# make attrs SAX style
sub _fixup_attrs {
    my ($parser, %attrs_of) = @_;

    my @attrs_from = map { $_ =
        {
            Name => $_,
            Value => $attrs_of{ $_ },
            LocalName => $_
        }
    } keys %attrs_of;

    # add xmlns: attrs. expat eats them.
    push @attrs_from, map {
        # ignore xmlns=FOO namespaces - must be XML schema
        # Other nodes should be ignored somewhere else
        ($_ eq '#default')
        ? ()
        :
        {
            Name => "xmlns:$_",
            Value => $parser->expand_ns_prefix( $_ ),
            LocalName => $_
        }
    } $parser->new_ns_prefixes();
    return @attrs_from;
}

1;

