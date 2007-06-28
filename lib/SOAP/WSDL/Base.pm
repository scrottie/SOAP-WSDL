package SOAP::WSDL::Base;
use strict;
use warnings;
use Carp;
use Class::Std::Storable;

my %id_of :ATTR(:name<id> :default<()>);
my %name_of :ATTR(:name<name> :default<()>);
my %targetNamespace_of :ATTR(:name<targetNamespace> :default<()>);
my %xmlns_of :ATTR(:name<xmlns> :default<{}>);

sub STORABLE_freeze_pre :CUMULATIVE {};
sub STORABLE_freeze_post :CUMULATIVE {};
sub STORABLE_thaw_pre :CUMULATIVE {};
sub STORABLE_thaw_post :CUMULATIVE { return $_[0] };

# unfortunately, AUTOMETHOD is SLOW.
# Re-implement in derived package wherever speed is an issue...
#
sub AUTOMETHOD {
    my ($self, $ident, @values) = @_;
    my $subname = $_;   # Requested subroutine name is passed via $_

    # we're called as $self->push_something(@values);
    if ($subname =~s{^push_}{}xms) {
        # we're not paranoid - we could be checking get_subname, too
        my $getter = "get_$subname";
        my $setter = "set_$subname";
        croak "no set accessor found for push_$subname"
            if not ($self->can( $setter ));
        return sub {
            no strict qw(refs);
            my $old_value = $self->$getter();
            # Listify if not a list ref
            $old_value = $old_value ? [ $old_value ] : [] if not ref $old_value;

            push @$old_value , @values;
            $self->$setter( $old_value );
        };
    }

    # we're called as $obj->find_something($ns, $key)
    elsif ($subname =~s {^find_}{get_}xms) {
        return sub {
            my @found_at = grep {
                $_->get_targetNamespace() eq $values[0] &&
                $_->get_name() eq $values[1]
            }
            @{ $self->$subname() };
            return $found_at[0];
        }
    }
    elsif ($subname =~s {^first_}{get_}xms) {
        return sub {
            my $result_ref = $self->$subname();
            return if not $result_ref;
            return $result_ref if (not ref $result_ref eq 'ARRAY');
            return $result_ref->[0];
        };
    }
    croak "$subname not found in class " . (ref $self || $self);
}

#sub to_string :STRINGIFY {
#    $_[0]->_DUMP();
#}

sub init {
	my $self = shift;
	my @args = @_;
	foreach my $value (@args)
	{
		die $value if (not defined ($value->{ Name }));
		if ($value->{ Name } =~m{^xmlns\:}xms) {
            die $xmlns_of{ ident $self }
                if ref $xmlns_of{ ident $self } ne 'HASH';
            $xmlns_of{ ident $self }->{ $value->{ Value } } =
                $value->{ LocalName };
			next;
		}
        elsif ($value->{ Name } =~m{^xmlns$}xms) {
            # just ignore xmlns = for now
            # TODO handle xmlns correctly - maybe via setting a prefix ?
            next;
        }
		my $name = $value->{ LocalName };
		my $method = "set_$name";
		$self->$method( $value->{ Value } )	if ( $method );
	}
    return $self;
}

sub add_namespace {
	my ($self, $uri, $prefix ) = @_;
	return unless $uri;
	$self->{ namespace } ||= {};
	$self->{ namespace }->{ $uri } = $prefix;
}

sub to_typemap {
    warn "to_typemap";
    return q{};
}

1;
