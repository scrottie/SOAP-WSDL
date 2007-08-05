#!/usr/bin/perl -w
use strict;
use warnings;
use Fcntl;
use IO::File;
use Pod::Usage;
use Getopt::Long;
use LWP::UserAgent;
use SOAP::WSDL::SAX::WSDLHandler;
use XML::LibXML;

my %opt = (
  url => '',
  prefix => undef,
  type_prefix => 'MyTypes::',
  element_prefix => 'MyElements::',
  typemap_prefix => 'MyTypemaps::',
  interface_prefix => 'MyInterfaces::',
  base_path => 'lib/',
  proxy => undef
);

GetOptions(\%opt,
  qw( 
    url|u=s
    prefix|p=s
    type_prefix|t=s
    element_prefix|e=s
    typemap_prefix|m=s
    base_path|b=s
    typemap_include|mi=s
    help|h
    proxy|x=s
  )
);

my $url = $ARGV[0];

pod2usage( -exit => 1 , verbose => 2 ) if ($opt{help});
pod2usage( -exit => 1 , verbose => 1 ) if not ($url);

my $handler = SOAP::WSDL::SAX::WSDLHandler->new();
my $parser = XML::LibXML->new();

local $ENV{HTTP_PROXY} = $opt{proxy} if $opt{proxy};
my $lwp = LWP::UserAgent->new();
my $response = $lwp->get($url);
die $response->message(), "\n" if $response->code != 200;

my $xml = $response->content();

$parser->set_handler( $handler );
$parser->parse_string( $xml );

my $wsdl = $handler->get_data();

if ($opt{typemap_include}) {
  my $fh = IO::File->new($opt{typemap_include} , O_RDONLY)
    or die "cannot open typemap_include file $opt{typemap_include}\n";
  $opt{custom_types} = join q{}, $fh->getlines();
  $fh->close();
  delete $opt{typemap_include};
}

$wsdl->create({ %opt });

=pod

=head1 NAME

wsdl2perl.pl - create perl bindings for SOAP webservices.

=head1 SYNOPSIS

 wsdl2perl.pl -t TYPE_PREFIX -e ELEMENT_PREFIX -m TYPEMAP_PREFIX \
   -i INTERFACE_PREFIX -b BASE_DIR URL

=head1 OPTIONS

 NAME            SHORT  DESCRITPION
 ----------------------------------------------------------------------------
 prefix            p   Prefix for both type and element classes.
 type_prefix       t   Prefix for type classes. Should end with '::' 
                       Default: MyTypes::
 element_prefix    e   Prefix for element classes. Should end with '::'
                       Default: MyElements::
 typemap_prefix    m   Prefix for typemap classes. Should end with '::'
                       Default: MyTypemaps::
 interface_prefix  i   Prefix for interface classes. Should end with '::'
                       Default: MyInterfaces::
 base_path         b   Path to create classes in.
                       Default: ./lib
 typemap_include   mi  File to include in typemap.
 help              h   Show help content

=head1 DESCRIPTION

Generates a interface class for a SOAP web service described by a WSDL 
definition.

The following classes are created:

=over

=item * A interface class for every service

Interface classes are what you will mainly deal with: They provide a method 
for accessing every web service method.

=item * A typemap for every service

Typemaps are used internally by SOAP::WSDL for parsing the SOAP message into 
object trees. 

If the WSDL definition is incomplete, you may need to add some lines to 
your typemap. Especially definitions for faults are sometimes left out.

Additional typemap content may be included by passing a file name as 
typemap_include (mi) option.

=item * A type class for every element, complexType or simpleType definition

You may need to write additional type classes if your WSDL is incomplete.

For writing your own lib classes, see L<SOAP::WSDL::XSD::Typelib::Element>,
L<SOAP::WSDL::XSD::Typelib::ComplexType> and L<SOAP::WSDL::XSD::Typelib::SimpleType>.

=back

=head1 LICENSE

Copyright 2007 Martin Kutter.

This file is part of SOAP-WSDL. You may distribute/modify it under 
the same terms as perl itself

=head1 AUTHOR

Martin Kutter E<lt>martin.kutter fen-net.deE<gt>

=cut
