use Test::More tests => 7;
use strict;
use warnings;

# use_ok fails to trigger Class::Std's overloading attributes
use SOAP::WSDL::SOAP::Typelib::Fault11;

my $fault = SOAP::WSDL::SOAP::Typelib::Fault11->new({
    faultcode => 'soap:Server',
    faultstring => 'Fault message',
});

ok "$fault", 'stringification'; 

if ($fault)  { fail 'boolify' } else { pass 'boolify' }

ok ! $fault->as_bool() , 'as_bool';

ok ! $fault->get_xmlns(), q(No explicit xmlns value);

is $fault->get_faultcode(), 'soap:Server', 'content';
is $fault->get_faultstring(), 'Fault message', 'content';

SKIP: {
        subtest q(Valid "Fault" object) => sub {
            my @optional_packages = qw<
                File::Spec
                XML::Compile::Translate::Reader XML::Compile::WSDL11 XML::Compile::SOAP11
            >;
            for (@optional_packages) {
                eval qq(require $_);
                if ($@) {
                    plan skip_all => qq(Package $_ is missing);
                    last;
                }
            } ## end for (@optional_packages)

            use_ok($_) for (@optional_packages);

            ### use the package WSDL file
            use FindBin qw< $Bin >;
            my $wsdlfile = File::Spec->catfile($Bin,
                qw< .. .. ..  acceptance wsdl 11_helloworld.wsdl >);
            plan skip_all => qq(Expected WSDL file $wsdlfile is missing)
                unless -e $wsdlfile;

            ### Exists here:
            #   /usr/share/perl5/XML/Compile/SOAP11/xsd/soap-envelope.xsd
            #   It is part of Debian stretch package libxml-compile-soap-perl
            #   version 3.21-1
            my $env_xsd
                = q(/usr/share/perl5/XML/Compile/SOAP11/xsd/soap-envelope.xsd);
            plan skip_all => qq(Expected XSD file $env_xsd is missing)
                unless -e $env_xsd;

            my $wsdl = XML::Compile::WSDL11->new($wsdlfile);
            $wsdl->importDefinitions([$env_xsd]);
            my $translator = XML::Compile::Translate::Reader->new(q(READER),
                nss => $wsdl->namespaces);
            my $code = $wsdl->compile(READER =>
                    q({http://schemas.xmlsoap.org/soap/envelope/}Envelope));

            ### fault generated on Jul 1 2020
            #   Problem ist the "<Fault xmlns=..." part.
            my $invalid_fault = <<EOFAULT;
<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
   <SOAP-ENV:Body>
      <Fault xmlns="http://schemas.xmlsoap.org/soap/envelope/">
         <faultcode>403</faultcode>
         <faultstring>An error message</faultstring>
         <faultactor>urn:localhost</faultactor>
      </Fault>
   </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
EOFAULT

            ### prove it's invalid
            eval { $code->($invalid_fault) };
            like(
                $@,
                qr/data for element or block starting with `faultcode' missing/,
                q(XML is invalid)
            );

            ### generate the new shiny valid fault
            #   it is wrapped in an envelop like the fault above
            my $valid_xml = <<EOFAULT;
<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
    <SOAP-ENV:Body>
        $fault
    </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
EOFAULT
            ##diag($valid_xml);
            my $fault_hash = eval { $code->($valid_xml) };
            ok(!$@, q(No exception raised));
            if (ref $fault_hash eq q(HASH)) {
                ok(exists $fault_hash->{Body}, q(Found response body));
            }
            else {
                fail(q(Result is not the expected hash reference));
            }
        };
    } ## end SKIP:
