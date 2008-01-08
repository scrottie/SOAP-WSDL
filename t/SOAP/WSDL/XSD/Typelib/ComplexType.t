use strict;
use warnings;

package MyEmptyType;
use base qw(SOAP::WSDL::XSD::Typelib::ComplexType);
__PACKAGE__->_factory([],{},{});

package MyEmptyType2;
use base qw(SOAP::WSDL::XSD::Typelib::ComplexType);
__PACKAGE__->_factory();

package MyType;

use base qw(SOAP::WSDL::XSD::Typelib::ComplexType);

my %test_of :ATTR(:get<test>);

__PACKAGE__->_factory(
[ 'test' ],
{
    test => \%test_of,
},
{
    test => 'SOAP::WSDL::XSD::Typelib::Builtin::string',
}
);

package MyType2;

use base qw(SOAP::WSDL::XSD::Typelib::ComplexType);

my %test2_of :ATTR(:get<test>);

__PACKAGE__->_factory(
[ 'test' ],
{
    test => \%test2_of,
},
{
    test => 'MyType',
}
);

package main;
use Test::More tests => 100;
use Storable;

my $have_warn = eval { require Test::Warn; import Test::Warn; 1; };

my $obj;

$obj = MyEmptyType->new();
is $obj->serialize, '';
is $obj->serialize({ name => 'test'}), '<test />';

$obj = MyEmptyType2->new();
is $obj->serialize, '';
is $obj->serialize({ name => 'test'}), '<test />';


$obj = MyType->new({});
isa_ok $obj, 'MyType';
is $obj->get_test, undef, 'undefined element content';

my $hash_of_ref = $obj->as_hash_ref();
is scalar keys %{ $hash_of_ref }, 0;

SKIP: {
    skip 'Cannot test warnings without Test::Warn', 1 if not $have_warn;
    warning_is( sub { $obj->add_test() }, 'attempting to add empty value to MyType' );
}

$obj = MyType->new({ test => 'Test1'});
isa_ok $obj, 'MyType';
isa_ok $obj->get_test, 'SOAP::WSDL::XSD::Typelib::Builtin::string';
is $obj->get_test, 'Test1', 'element content';

$obj = MyType->new({ 
    test => SOAP::WSDL::XSD::Typelib::Builtin::string->new({ 
        value => 'Test2'
    })
});
isa_ok $obj, 'MyType';
isa_ok $obj->get_test, 'SOAP::WSDL::XSD::Typelib::Builtin::string';
is $obj->get_test, 'Test2', 'element content';

$obj = MyType->new({ 
    test => { value => 'Test2' } # just a trick - pass it unaltered to new...
});
isa_ok $obj, 'MyType';
isa_ok $obj->get_test, 'SOAP::WSDL::XSD::Typelib::Builtin::string';
is $obj->get_test, 'Test2', 'element content';

$hash_of_ref = $obj->as_hash_ref();
is $hash_of_ref->{ test }, 'Test2';

$obj = MyType->new({ 
    test => [
        SOAP::WSDL::XSD::Typelib::Builtin::string->new({ 
            value => 'Test'
        }),

        SOAP::WSDL::XSD::Typelib::Builtin::string->new({ 
            value => 'Test2'
        })
    ],
});
isa_ok $obj, 'MyType';
isa_ok $obj->get_test, 'ARRAY';
is $obj->get_test()->[0], 'Test', 'element content (list content [0])';
is $obj->get_test()->[1], 'Test2', 'element content (list content [1])';

$hash_of_ref = $obj->as_hash_ref();
is $hash_of_ref->{ test }->[0], 'Test';
is $hash_of_ref->{ test }->[1], 'Test2';

my $nested = MyType2->new({
    test => $obj,
});

is $nested->get_test, $obj, 'getter';
$nested = MyType2->new({
    test => [$obj, $obj],
});

is $nested->get_test->[0], $obj;

$nested = MyType2->new({
    test => {
        test => [
            SOAP::WSDL::XSD::Typelib::Builtin::string->new({ 
                value => 'Test'
            }),
    
            SOAP::WSDL::XSD::Typelib::Builtin::string->new({ 
                value => 'Test2'
            })
        ],
    },    
});


$hash_of_ref = $nested->as_hash_ref();
is $hash_of_ref->{ test }->{ test }->[1], 'Test2';


# isnt $nested->get_test->[0], $obj, 'element identity';

$obj = MyType->new();
isa_ok $obj, 'MyType';
is $obj->get_test, undef, 'undefined element content';

$obj->add_test(
    SOAP::WSDL::XSD::Typelib::Builtin::string->new({ value => 'TestString0'})
);
is $obj->get_test, 'TestString0', 'added element content';

for my $count (1..5) {
    $obj->add_test(
        SOAP::WSDL::XSD::Typelib::Builtin::string->new({ value => "TestString$count" })
    );

    is ref $obj->get_test(), 'ARRAY', 'element content structure';
    is @{ $obj->get_test() }, $count+1, "element list length: " . ($count + 1);

    for my $index (0..$count-1) {
        is $obj->get_test->[$index], "TestString$index", "element content [$index]";
    }
}

# TODO - remove after *{ "$class\::$name"" } methods are gone

$obj = MyType->new();

isa_ok $obj, 'MyType';
is $obj->get_test, undef;

{
    no warnings;
    my $foo;
    eval { $foo = @{ $obj->get_test() } };
    if (! $@) {
        is $foo, undef;
#        like $warnings,  qr{ uninitialized \s value \s in array \s dereference }x, 'undef warning';
    } 
    else {
        like $@ , qr{Can't \s use \s an \s undefined}x, 'get_ELEMENT still undef on ARRAYIFY';
#        pass 'failed array dereference';
    }

    $obj->test(
        SOAP::WSDL::XSD::Typelib::Builtin::string->new({ value => 'TestString0'})
    );
}
is $obj->get_test, 'TestString0';
eval { is @{ $obj->get_test() }, 1, 'ARRAYIFY get_ELEMENT' };
fail 'cannot ARRAYIFY get_ELEMENT' if ($@);

my @serialized = (
'<test >TestString0</test ><test >TestString1</test >',
'<test >TestString0</test ><test >TestString1</test ><test >TestString2</test >',
'<test >TestString0</test ><test >TestString1</test ><test >TestString2</test ><test >TestString3</test >',
'<test >TestString0</test ><test >TestString1</test ><test >TestString2</test ><test >TestString3</test ><test >TestString4</test >',
'<test >TestString0</test ><test >TestString1</test ><test >TestString2</test ><test >TestString3</test ><test >TestString4</test ><test >TestString5</test >',
);

for my $count (1..5) {
    $obj->test(
        SOAP::WSDL::XSD::Typelib::Builtin::string->new({ value => "TestString$count" })
    );

    is ref $obj->get_test(), 'ARRAY';
    is @{ $obj->get_test() }, $count+1;

    for my $index (0..$count-1) {
        is $obj->get_test->[$index], "TestString$index";
    }
    is $obj->serialize(), $serialized[$count -1];
    
}


eval {
    $obj = MyType->new({ 
    test => [
            SOAP::WSDL::XSD::Typelib::Builtin::string->new({ 
                value => 'Test'
            }),

            \&CORE::die,
        ],
    });
};
like $@, qr{cannot \s use \s CODE}xms;

eval {
    $obj = MyType->new({ 
    test => \&CORE::die,
    });
};
like $@, qr{cannot \s use \s CODE}xms;


eval {
    $obj = MyType->new({ 
        foobar => 'fubar'
    });
};
like $@, qr{unknown \s field \s foobar \s in \s MyType }xms;


eval { $obj->set_FOO(42) };
like $@, qr{Can't \s locate \s object \s method}x;

eval { MyType->set_FOO(42) };
like $@, qr{Can't \s locate \s object \s method}x;

eval { MyType->new({ FOO => 42 }) };
like $@, qr{unknown \s field \s}xm;

my $clone = Storable::thaw( Storable::freeze( $obj ));
is $clone->get_test()->[0], 'TestString0';

eval { SOAP::WSDL::XSD::Typelib::ComplexType::AUTOMETHOD() };
like $@, qr{Cannot \s call}xm;


eval { SOAP::WSDL::XSD::Typelib::ComplexType->_factory([], { test => {} }, {}) };
like $@, qr{ No \s class \s given \s for \s }xms;

eval { SOAP::WSDL::XSD::Typelib::ComplexType->_factory([], { test => {} }, { test => 'HopeItDoesntExistOnYourSystem'}) };
like $@, qr{ Can't \s locate \s HopeItDoesntExistOnYourSystem.pm }xms;

