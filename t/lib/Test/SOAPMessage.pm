package Test::SOAPMessage;

use strict;

use SOAP::Lite;
use Test::Differences;
use Tie::IxHash;

use base qw/Exporter/;

our @EXPORT = qw/soap_eq_or_diff/;

sub soap_eq_or_diff
{
	my $got = shift;
	my $expected = shift;
	my $message = shift;
	my $soapGot = SOAP::Deserializer->deserialize( $got );
	my $soapExpected = SOAP::Deserializer->deserialize( $expected );

	return eq_or_diff(
		unlather( $soapGot ), 
		unlather( $soapExpected ),
		$message
	);
}

sub unlather
{
        my $som = shift;
        my $path = shift || '/Envelope/Body/[1]';
        my $data = shift;
        
        unless ( $data )
        {
        	my %hashData = ();
        	tie (%hashData, q/Tie::IxHash/);
        	$data = \%hashData;
        }
        
        my $value;
        my $tag;
        my $i = 1;
        while( $som->match("$path/[$i]") )
        {
                $tag = $som->dataof->name();
                $data ||= {};
                $value = unlather($som,$path.'/'. '[' . $i . ']' ) || $som->valueof("$path/[$i]");
                if ($data->{ $tag })
                {
                        $data->{ $tag } = [ $data->{ $tag } ] unless ( ref ( $data->{ $tag } ) eq 'ARRAY' );
                        push @{ $data->{ $tag } }, $value;
                }
                else
                {
                        $data->{ $tag } = $value;
                }
                $i++;
        }
        $data ||= $som->valueof($path);
        return $data;
}

1;