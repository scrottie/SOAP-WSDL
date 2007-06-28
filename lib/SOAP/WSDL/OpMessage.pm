package SOAP::WSDL::OpMessage;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::Base);

my %body_of     :ATTR(:name<body> :default<()>);
my %message_of  :ATTR(:name<message> :default<()>);
my %use_of      :ATTR(:name<use> :default<()>);
my %namespace   :ATTR(:name<namespace> :default<()>);
my %encodingStyle_of :ATTR(:name<encodingStyle> :default<()>);

sub explain
{
	my $self = shift;
	my $opt = shift;
	my $name = shift;
	my $txt = '';

	my %ns_map = reverse %{ $opt->{ wsdl }->get_xmlns() };

	if ( $self->get_message() )	{

		my ($prefix, $localname) = split /:/ , $self->get_message();

        # TODO allow more messages && overloading by specifying name
		my $message = $opt->{ wsdl }->get_message(
			$ns_map{ $prefix }, $localname
		);

		for my $part(@{ $message->[0]->get_part() }) {
			$opt->{ indent } .= "\t";
			$txt .= $part->explain($opt);
			$opt->{ indent } =~s/\t//;
    		$txt  .= $opt->{ indent } . "\n";
        }
	}
	else
	{
		if ($self->use())
		{
			$txt .= $opt->{ indent } . "$name use: " . $self->use(). "\n";
		}
	}
	return $txt;
}

sub to_typemap {

    my ($self, $opt) = @_;
    my $txt = q{};
    return q{} if not ( $self->get_message() ); # we're in binding
    my %ns_map = reverse %{ $opt->{ wsdl }->get_xmlns() };
    my ($prefix, $localname) = split /:/ , $self->get_message();

    # TODO allow more messages && overloading by specifying name
    my $message = $opt->{ wsdl }->find_message(
        $ns_map{ $prefix }, $localname
    );

    for my $part(@{ $message->get_part() }) {
         $txt .= $part->to_typemap($opt);
    }
    return $txt;
}

1;
