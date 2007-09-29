package SOAP::WSDL::Base;
use strict;
use warnings;
use Class::Std::Storable;
use List::Util qw(first);
use Carp;

my %id_of :ATTR(:name<id> :default<()>);
my %name_of :ATTR(:name<name> :default<()>);
my %documentation_of :ATTR(:name<documentation> :default<()>);
my %targetNamespace_of :ATTR(:name<targetNamespace> :default<()>);
my %xmlns_of :ATTR(:name<xmlns> :default<{}>);
my %parent_of :ATTR(:name<parent> :default<()>);

sub DEMOLISH {
  my $self = shift;
  # delete upward references
  delete $parent_of{ ident $self };
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
    no strict qw(refs);
    shift->$method( $self );
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
    confess "$subname not found in class " . (ref $self || $self) ;
}

sub init {
    my $self = shift;
    my @args = @_;
    foreach my $value (@args)
    {
        die @args if (not defined ($value->{ Name }));
        if ($value->{ Name } =~m{^xmlns\:}xms) {
            die $xmlns_of{ ident $self }
                if ref $xmlns_of{ ident $self } ne 'HASH';

            # add namespaces
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
        $self->$method( $value->{ Value } );
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

sub expand {
    my ($self, , $qname) = @_;
    my ($prefix, $localname) = split /:/, $qname;
    my %ns_map = reverse %{ $self->get_xmlns() };
    return ($ns_map{ $prefix }, $localname) if ($ns_map{ $prefix });
    
    if (my $parent = $self->get_parent()) {
        return $parent->expand($qname);
    }
    die "unbound prefix $prefix found for $prefix:$localname";
}
sub _expand; 
*_expand = \&expand;


sub to_class {
    my $self = shift;
    my $opt = shift;
    my $template = shift;

    $opt->{ base_path } ||= '.';

    my $element_prefix = $opt->{ element_prefix } || $opt->{ prefix };
    my $type_prefix = $opt->{ type_prefix } || $opt->{ prefix };
    
    if (($type_prefix) && ($type_prefix !~m{ :: $ }xms ) )  {
      warn 'type_prefix should end with "::"';
      $type_prefix .= '::';
    }

    if (($element_prefix) && ($element_prefix !~m{ :: $ }xms) ) {
      warn 'element_prefix should end with "::"';
      $element_prefix .= '::';
    }

    # Be careful: a Element may be ComplexType, too 
    # (but not vice versa)
    my $prefix = $self->isa('SOAP::WSDL::XSD::Element') 
      ? $element_prefix
      : $type_prefix;

    die 'No prefix specified' if not $prefix;

    my $filename = $prefix . $self->get_name() . '.pm';
    $filename =~s{::}{/}xmsg;

    my $output = $opt->{ output } || $filename; 

    require Template;
    my $tt = Template->new(
            RELATIVE => 1,    
            OUTPUT_PATH => $opt->{ base_path },
    );
    
    my $code = $tt->process( \$template, {
            element_prefix => $element_prefix,
            type_prefix => $type_prefix,
            self => $self, 
            nsmap => { reverse %{ $opt->{ wsdl }->get_xmlns() } },
            structure => $self->explain( { wsdl => $opt->{ wsdl } } ),
        }, 
        $output
    )
    or die $tt->error();
}
1;
