package MyInterfaces::FullerData_x0020_Fortune_x0020_Cookie;
use strict;
use warnings;
use MyTypemaps::FullerData_x0020_Fortune_x0020_Cookie;
use base 'SOAP::WSDL::Client::Base';

sub new {
    my $class = shift;
    my $arg_ref = shift || {};
    my $self = $class->SUPER::new({
        class_resolver => 'MyTypemaps::FullerData_x0020_Fortune_x0020_Cookie',
        proxy => 'http://www.fullerdata.com/FortuneCookie/FortuneCookie.asmx',
        %{ $arg_ref }
    });
    return bless $self, $class;
}

__PACKAGE__->__create_methods(
              GetSpecificCookie => [ 'MyElements::GetSpecificCookie', ],
              CountCookies => [ 'MyElements::CountCookies', ],
              readNodeCount => [ 'MyElements::readNodeCount', ],
              GetFortuneCookie => [ 'MyElements::GetFortuneCookie', ],
      
);

1;

__END__

=pod

=head1 NAME 

MyInterfaces::FullerData_x0020_Fortune_x0020_Cookie - SOAP interface to FullerData_x0020_Fortune_x0020_Cookie at 
http://www.fullerdata.com/FortuneCookie/FortuneCookie.asmx

=head1 SYNOPSIS

 my $interface = MyInterfaces::FullerData_x0020_Fortune_x0020_Cookie->new();
 my $CountCookies = $interface->CountCookies();


=head1 Service FullerData_x0020_Fortune_x0020_Cookie

=head2 Service information:

 Port name: FullerData_x0020_Fortune_x0020_CookieSoap
 Binding: tns:FullerData_x0020_Fortune_x0020_CookieSoap
 Location: http://www.fullerdata.com/FortuneCookie/FortuneCookie.asmx

=head2 SOAP Operations 

B<Note:>

 Input, output and fault messages are stated as perl hash refs. 
 
 These are only for informational purposes - the actual implementation 
 normally uses object trees, not hash refs, though the input messages 
 may be passed to the respective methods as hash refs and will be 
 converted to object trees automatically.


=head3 readNodeCount

B<Input Message:>

 {
 }


B<Output Message:>

 {
 }


B<Fault:>




=head3 GetFortuneCookie

B<Input Message:>

 {
 }


B<Output Message:>

 {
 }


B<Fault:>




=head3 CountCookies

B<Input Message:>

 {
 }


B<Output Message:>

 {
 }


B<Fault:>




=head3 GetSpecificCookie

B<Input Message:>

 {
 }


B<Output Message:>

 {
 }


B<Fault:>



=head2 Service information:

 Port name: FullerData_x0020_Fortune_x0020_CookieHttpGet
 Binding: tns:FullerData_x0020_Fortune_x0020_CookieHttpGet
 Location: 

=head2 SOAP Operations 

B<Note:>

 Input, output and fault messages are stated as perl hash refs. 
 
 These are only for informational purposes - the actual implementation 
 normally uses object trees, not hash refs, though the input messages 
 may be passed to the respective methods as hash refs and will be 
 converted to object trees automatically.


=head3 readNodeCount

B<Input Message:>

 {
 }


B<Output Message:>

 {
 }


B<Fault:>




=head3 GetFortuneCookie

B<Input Message:>

 {
 }


B<Output Message:>

 {
 }


B<Fault:>




=head3 CountCookies

B<Input Message:>

 {
 }


B<Output Message:>

 {
 }


B<Fault:>




=head3 GetSpecificCookie

B<Input Message:>

 {
 }


B<Output Message:>

 {
 }


B<Fault:>



=head2 Service information:

 Port name: FullerData_x0020_Fortune_x0020_CookieHttpPost
 Binding: tns:FullerData_x0020_Fortune_x0020_CookieHttpPost
 Location: 

=head2 SOAP Operations 

B<Note:>

 Input, output and fault messages are stated as perl hash refs. 
 
 These are only for informational purposes - the actual implementation 
 normally uses object trees, not hash refs, though the input messages 
 may be passed to the respective methods as hash refs and will be 
 converted to object trees automatically.


=head3 readNodeCount

B<Input Message:>

 {
 }


B<Output Message:>

 {
 }


B<Fault:>




=head3 GetFortuneCookie

B<Input Message:>

 {
 }


B<Output Message:>

 {
 }


B<Fault:>




=head3 CountCookies

B<Input Message:>

 {
 }


B<Output Message:>

 {
 }


B<Fault:>




=head3 GetSpecificCookie

B<Input Message:>

 {
 }


B<Output Message:>

 {
 }


B<Fault:>





=cut

