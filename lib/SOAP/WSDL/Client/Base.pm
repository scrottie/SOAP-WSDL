#!/usr/bin/perl -w
package SOAP::WSDL::Client::Base;

################################################################################## 
## <OWNER>Internetteam
## <AUTHOR>Martin Kutter <martin.kutter@siemens.com>
## <CREATIONDATE>25.10.2006
##
## <FUNCTION>Base client for WSDL-based SOAP access
## Automatisch gefüllt:
## <CVSPROJECT>$HeadURL:$
## <REVISION>$Revision:$
################################################################################

use strict;
use Log::Log4perl;

use Class::Accessor;

use base qw/Class::Accessor/;

$SOAP::WSDL::Client::Base::VERSION = sprintf("0.%d", q$LastChangedRevision: 1$ =~/(\d+)/ );

__PACKAGE__->mk_accessors( 
	qw// 
);

my $log = undef;	# Global logger to speed up performance

=pod

=head1 NAME

SOAP::WSDL::Client::Base - Base client for WSDL-based SOAP access

=head1 SYNOPSIS

 use SOAP::WSDL::Client::Base;

# TODO Add more Synopsis information

=head1 DESCRIPTION

# TODO Add Description

=cut

=pod

=head2 new

=over

=item SYNOPSIS

 my $obj = ->new();

=item DESCRIPTION

Constructor.

=back

=cut

sub new
{
	my $proto = shift;
	my $class = ref $proto || $proto;
	my $self = {
			soapBindingStyle => 'rpc',
		};
	bless $self, $class;
	$self->init(@_);
	return $self;
}

sub soapBindingStyle
{
	my $self = shift;
	my $style = shift;
	if ($style)
	{
		die "Binding style must be one of rpc|document" 
			if (not( $style=~m/^(rpc|document)$/));
		$self->{ soapBindingStyle } = $style;
	}
	return $self->{ soapBindingStyle };
}

sub init
{
}

sub call
{
	my $self = shift;
	my $method = shift;
	my $data = shift;
	my $content;
}

1;

__END__

=pod

=head1 AUTHOR

Martin Kutter <martin.kutter@siemens.com>

=head1 COPYING

Copyright (c) 2005 SIEMENS AG. All rights reserved.

=head1 Repository information

 $ID: $

 $LastChangedDate: $
 $LastChangedRevision: $
 $LastChangedBy: $

 $HeadURL: $

=cut