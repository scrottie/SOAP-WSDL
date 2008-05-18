package SOAP::WSDL::Base;
use strict;
use warnings;
use Class::Std::Fast::Storable;
use List::Util qw(first);
use Carp qw(croak carp confess);

use version; our $VERSION = qv('2.00.03');

my %id_of               :ATTR(:name<id> :default<()>);
my %lang_of             :ATTR(:name<lang> :default<()>);
my %name_of             :ATTR(:name<name> :default<()>);
my %documentation_of    :ATTR(:name<documentation> :default<()>);
my %annotation_of       :ATTR(:name<annotation> :default<()>);
my %targetNamespace_of  :ATTR(:name<targetNamespace> :default<()>);
my %xmlns_of            :ATTR(:name<xmlns> :default<{}>);
my %parent_of           :ATTR(:name<parent> :default<()>);

my %namespaces_of       :ATTR(:default<{}>);

sub namespaces {
    return shift->get_xmlns();
}

sub START {
    my ($self, $ident, $arg_ref) = @_;
    #$xmlns_of{ $ident }->{ '#default' } = $self->get_xmlns()->{ '#default' };
    $xmlns_of{ $ident }->{ 'xml' } = 'http://www.w3.org/XML/1998/namespace';
    $namespaces_of{ $ident }->{ '#default' } = $self->get_xmlns()->{ '#default' };
    $namespaces_of{ $ident }->{ 'xml' } = 'http://www.w3.org/XML/1998/namespace';

}

sub DEMOLISH {
  my $self = shift;
  # delete upward references
  delete $parent_of{ ${ $self } };
  return;
}

sub STORABLE_freeze_pre :CUMULATIVE {};
sub STORABLE_freeze_post :CUMULATIVE {};
sub STORABLE_thaw_pre :CUMULATIVE {};
sub STORABLE_thaw_post :CUMULATIVE { return $_[0] };

sub _accept {
    my $self = shift;
    my $class = ref $self;
    $class =~ s{ \A SOAP::WSDL:: }{}xms;
    $class =~ s{ (:? :: ) }{_}gxms;
    my $method = "visit_$class";
    no strict qw(refs); ## no critic ProhibitNoStrict
    return shift->$method( $self );
}

# unfortunately, AUTOMETHOD is SLOW.
# Re-implement in derived package wherever speed is an issue...
#
sub AUTOMETHOD {
    my ($self, $ident, @values) = @_;
    my $subname = $_;   # Requested subroutine name is passed via $_

    # we're called as $self->push_something(@values);
    if ($subname =~s{^push_}{}xms) {
        my $getter = "get_$subname";
        my $setter = "set_$subname";
        ## Checking here is paranoid - will fail fatally if
        ## there is no setter...
        ## And we would have to check getters, too.
        ## Maybe do it the Conway way via the Symbol table...
        ## ... can is way slow...
        return sub {
            no strict qw(refs);                 ## no critic ProhibitNoStrict
            my $old_value = $self->$getter();
            # Listify if not a list ref
            $old_value = $old_value ? [ $old_value ] : [] if not ref $old_value;

            push @$old_value , @values;
            $self->$setter( $old_value );
        };
    }

    # we're called as $obj->find_something($ns, $key)
    elsif ($subname =~s {^find_}{get_}xms) {
        @values = @{ $values[0] } if ref $values[0] eq 'ARRAY';
        return sub {
            return first {
                $_->get_targetNamespace() eq $values[0] &&
                $_->get_name() eq $values[1]
            }
            @{ $self->$subname() };
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

    # return if called from can();
    my @caller = caller(2);
    return if ($caller[3] eq 'Class::Std::Fast::__ANON__');
    # confess "$subname not found in class " . ref $self;
    return;
}

sub init {
    my ($self, @args) = @_;
    foreach my $value (@args)
    {
        croak @args if (not defined ($value->{ Name }));
        if ($value->{ Name } =~m{^xmlns\:}xms) {
            # add namespaces
            $xmlns_of{ ident $self }->{ $value->{ LocalName } } = $value->{ Value };
            next;
        }

        my $name = $value->{ LocalName };
        my $method = "set_$name";
        $self->$method( $value->{ Value } );
    }
    return $self;
}

sub expand {
    my ($self, $qname) = @_;
    my $ns_of = $self->namespaces();
    if (not $qname=~m{:}xm) {
        if (defined $ns_of->{ '#default' }) {
            return $self->get_targetNamespace(), $qname;
            # return $ns_of->{ '#default' }, $qname;
        }
        if (my $parent = $self->get_parent()) {
            return $parent->expand($qname);
        }
        die "un-prefixed element name <$qname> found, but no default namespace set\n"
    }

    my ($prefix, $localname) = split /:/x, $qname;

    return ($ns_of->{ $prefix }, $localname) if ($ns_of->{ $prefix });
    if (my $parent = $self->get_parent()) {
        return $parent->expand($qname);
    }
    croak "unbound prefix $prefix found for $prefix:$localname. Bound prefixes are "
        . join(', ', keys %{ $ns_of });
}
sub _expand;
*_expand = \&expand;

1;

__END__

# REPOSITORY INFORMATION
#
# $Rev: 332 $
# $LastChangedBy: kutterma $
# $Id: WSDL.pm 332 2007-10-19 07:29:03Z kutterma $
# $HeadURL: http://soap-wsdl.svn.sourceforge.net/svnroot/soap-wsdl/SOAP-WSDL/trunk/lib/SOAP/WSDL.pm $
#

