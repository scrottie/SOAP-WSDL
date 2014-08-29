# This Makefile is for the SOAP::WSDL extension to perl.
#
# It was generated automatically by MakeMaker version
# 6.88 (Revision: 68800) from the contents of
# Makefile.PL. Don't edit this file, edit Makefile.PL instead.
#
#       ANY CHANGES MADE HERE WILL BE LOST!
#
#   MakeMaker ARGV: ()
#

#   MakeMaker Parameters:

#     ABSTRACT_FROM => q[lib/SOAP/WSDL.pm]
#     AUTHOR => [q[Scott Walters <scott@slowass.net>]]
#     BUILD_REQUIRES => {  }
#     CONFIGURE_REQUIRES => {  }
#     NAME => q[SOAP::WSDL]
#     PREREQ_PM => { Data::Dumper=>q[0], Date::Parse=>q[0], Storable=>q[0], Getopt::Long=>q[0], Module::Build=>q[0], Class::Std::Fast=>q[0.000005], URI=>q[0], Test::More=>q[0], XML::Parser::Expat=>q[0], File::Spec=>q[0], Cwd=>q[0], File::Basename=>q[0], List::Util=>q[0], Template=>q[2.18], perl=>q[5.008], Date::Format=>q[0], LWP::UserAgent=>q[0], Term::ReadKey=>q[0], File::Path=>q[0] }
#     TEST_REQUIRES => {  }
#     VERSION_FROM => q[lib/SOAP/WSDL.pm]
#     test => { RECURSIVE_TEST_FILES=>q[1] }

# --- MakeMaker post_initialize section:


# --- MakeMaker const_config section:

# These definitions are from config.sh (via /usr/local/lib/perl5/5.19.9/i686-linux/Config.pm).
# They may have been overridden via Makefile.PL or on the command line.
AR = ar
CC = cc
CCCDLFLAGS = -fPIC
CCDLFLAGS = -Wl,-E
DLEXT = so
DLSRC = dl_dlopen.xs
EXE_EXT = 
FULL_AR = /usr/bin/ar
LD = cc
LDDLFLAGS = -shared -O2 -L/usr/local/lib -fstack-protector
LDFLAGS =  -fstack-protector -L/usr/local/lib
LIBC = libc-2.13.so
LIB_EXT = .a
OBJ_EXT = .o
OSNAME = linux
OSVERS = 3.4.4
RANLIB = :
SITELIBEXP = /usr/local/lib/perl5/site_perl/5.19.9
SITEARCHEXP = /usr/local/lib/perl5/site_perl/5.19.9/i686-linux
SO = so
VENDORARCHEXP = 
VENDORLIBEXP = 


# --- MakeMaker constants section:
AR_STATIC_ARGS = cr
DIRFILESEP = /
DFSEP = $(DIRFILESEP)
NAME = SOAP::WSDL
NAME_SYM = SOAP_WSDL
VERSION = 3.00.0_2
VERSION_MACRO = VERSION
VERSION_SYM = 3_00_0_2
DEFINE_VERSION = -D$(VERSION_MACRO)=\"$(VERSION)\"
XS_VERSION = 3.00.0_2
XS_VERSION_MACRO = XS_VERSION
XS_DEFINE_VERSION = -D$(XS_VERSION_MACRO)=\"$(XS_VERSION)\"
INST_ARCHLIB = blib/arch
INST_SCRIPT = blib/script
INST_BIN = blib/bin
INST_LIB = blib/lib
INST_MAN1DIR = blib/man1
INST_MAN3DIR = blib/man3
MAN1EXT = 1
MAN3EXT = 3
INSTALLDIRS = site
DESTDIR = 
PREFIX = $(SITEPREFIX)
PERLPREFIX = /usr/local
SITEPREFIX = /usr/local
VENDORPREFIX = 
INSTALLPRIVLIB = /usr/local/lib/perl5/5.19.9
DESTINSTALLPRIVLIB = $(DESTDIR)$(INSTALLPRIVLIB)
INSTALLSITELIB = /usr/local/lib/perl5/site_perl/5.19.9
DESTINSTALLSITELIB = $(DESTDIR)$(INSTALLSITELIB)
INSTALLVENDORLIB = 
DESTINSTALLVENDORLIB = $(DESTDIR)$(INSTALLVENDORLIB)
INSTALLARCHLIB = /usr/local/lib/perl5/5.19.9/i686-linux
DESTINSTALLARCHLIB = $(DESTDIR)$(INSTALLARCHLIB)
INSTALLSITEARCH = /usr/local/lib/perl5/site_perl/5.19.9/i686-linux
DESTINSTALLSITEARCH = $(DESTDIR)$(INSTALLSITEARCH)
INSTALLVENDORARCH = 
DESTINSTALLVENDORARCH = $(DESTDIR)$(INSTALLVENDORARCH)
INSTALLBIN = /usr/local/bin
DESTINSTALLBIN = $(DESTDIR)$(INSTALLBIN)
INSTALLSITEBIN = /usr/local/bin
DESTINSTALLSITEBIN = $(DESTDIR)$(INSTALLSITEBIN)
INSTALLVENDORBIN = 
DESTINSTALLVENDORBIN = $(DESTDIR)$(INSTALLVENDORBIN)
INSTALLSCRIPT = /usr/local/bin
DESTINSTALLSCRIPT = $(DESTDIR)$(INSTALLSCRIPT)
INSTALLSITESCRIPT = /usr/local/bin
DESTINSTALLSITESCRIPT = $(DESTDIR)$(INSTALLSITESCRIPT)
INSTALLVENDORSCRIPT = 
DESTINSTALLVENDORSCRIPT = $(DESTDIR)$(INSTALLVENDORSCRIPT)
INSTALLMAN1DIR = /usr/local/share/man/man1
DESTINSTALLMAN1DIR = $(DESTDIR)$(INSTALLMAN1DIR)
INSTALLSITEMAN1DIR = /usr/local/share/man/man1
DESTINSTALLSITEMAN1DIR = $(DESTDIR)$(INSTALLSITEMAN1DIR)
INSTALLVENDORMAN1DIR = 
DESTINSTALLVENDORMAN1DIR = $(DESTDIR)$(INSTALLVENDORMAN1DIR)
INSTALLMAN3DIR = /usr/local/share/man/man3
DESTINSTALLMAN3DIR = $(DESTDIR)$(INSTALLMAN3DIR)
INSTALLSITEMAN3DIR = /usr/local/share/man/man3
DESTINSTALLSITEMAN3DIR = $(DESTDIR)$(INSTALLSITEMAN3DIR)
INSTALLVENDORMAN3DIR = 
DESTINSTALLVENDORMAN3DIR = $(DESTDIR)$(INSTALLVENDORMAN3DIR)
PERL_LIB = /usr/local/lib/perl5/5.19.9
PERL_ARCHLIB = /usr/local/lib/perl5/5.19.9/i686-linux
LIBPERL_A = libperl.a
FIRST_MAKEFILE = Makefile
MAKEFILE_OLD = Makefile.old
MAKE_APERL_FILE = Makefile.aperl
PERLMAINCC = $(CC)
PERL_INC = /usr/local/lib/perl5/5.19.9/i686-linux/CORE
PERL = /usr/local/bin/perl
FULLPERL = /usr/local/bin/perl
ABSPERL = $(PERL)
PERLRUN = $(PERL)
FULLPERLRUN = $(FULLPERL)
ABSPERLRUN = $(ABSPERL)
PERLRUNINST = $(PERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
FULLPERLRUNINST = $(FULLPERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
ABSPERLRUNINST = $(ABSPERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
PERL_CORE = 0
PERM_DIR = 755
PERM_RW = 644
PERM_RWX = 755

MAKEMAKER   = /usr/local/lib/perl5/site_perl/5.19.9/ExtUtils/MakeMaker.pm
MM_VERSION  = 6.88
MM_REVISION = 68800

# FULLEXT = Pathname for extension directory (eg Foo/Bar/Oracle).
# BASEEXT = Basename part of FULLEXT. May be just equal FULLEXT. (eg Oracle)
# PARENT_NAME = NAME without BASEEXT and no trailing :: (eg Foo::Bar)
# DLBASE  = Basename part of dynamic library. May be just equal BASEEXT.
MAKE = make
FULLEXT = SOAP/WSDL
BASEEXT = WSDL
PARENT_NAME = SOAP
DLBASE = $(BASEEXT)
VERSION_FROM = lib/SOAP/WSDL.pm
OBJECT = 
LDFROM = $(OBJECT)
LINKTYPE = dynamic
BOOTDEP = 

# Handy lists of source code files:
XS_FILES = 
C_FILES  = 
O_FILES  = 
H_FILES  = 
MAN1PODS = 
MAN3PODS = lib/SOAP/WSDL.pm \
	lib/SOAP/WSDL/Client.pm \
	lib/SOAP/WSDL/Client/Base.pm \
	lib/SOAP/WSDL/Definitions.pm \
	lib/SOAP/WSDL/Deserializer/Hash.pm \
	lib/SOAP/WSDL/Deserializer/SOM.pm \
	lib/SOAP/WSDL/Deserializer/XSD.pm \
	lib/SOAP/WSDL/Expat/Base.pm \
	lib/SOAP/WSDL/Expat/Message2Hash.pm \
	lib/SOAP/WSDL/Expat/MessageParser.pm \
	lib/SOAP/WSDL/Expat/MessageStreamParser.pm \
	lib/SOAP/WSDL/Expat/WSDLParser.pm \
	lib/SOAP/WSDL/Factory/Deserializer.pm \
	lib/SOAP/WSDL/Factory/Generator.pm \
	lib/SOAP/WSDL/Factory/Serializer.pm \
	lib/SOAP/WSDL/Factory/Transport.pm \
	lib/SOAP/WSDL/Generator/Iterator/WSDL11.pm \
	lib/SOAP/WSDL/Generator/PrefixResolver.pm \
	lib/SOAP/WSDL/Generator/Template.pm \
	lib/SOAP/WSDL/Generator/Template/Plugin/XSD.pm \
	lib/SOAP/WSDL/Generator/Template/XSD.pm \
	lib/SOAP/WSDL/Generator/Visitor.pm \
	lib/SOAP/WSDL/Generator/Visitor/Typemap.pm \
	lib/SOAP/WSDL/Manual.pod \
	lib/SOAP/WSDL/Manual/CodeFirst.pod \
	lib/SOAP/WSDL/Manual/Cookbook.pod \
	lib/SOAP/WSDL/Manual/Deserializer.pod \
	lib/SOAP/WSDL/Manual/FAQ.pod \
	lib/SOAP/WSDL/Manual/Glossary.pod \
	lib/SOAP/WSDL/Manual/Parser.pod \
	lib/SOAP/WSDL/Manual/Serializer.pod \
	lib/SOAP/WSDL/Manual/WS_I.pod \
	lib/SOAP/WSDL/Manual/XSD.pod \
	lib/SOAP/WSDL/SOAP/Typelib/Fault11.pm \
	lib/SOAP/WSDL/Serializer/XSD.pm \
	lib/SOAP/WSDL/Server.pm \
	lib/SOAP/WSDL/Server/CGI.pm \
	lib/SOAP/WSDL/Server/Mod_Perl2.pm \
	lib/SOAP/WSDL/Server/Simple.pm \
	lib/SOAP/WSDL/Transport/HTTP.pm \
	lib/SOAP/WSDL/Transport/Loopback.pm \
	lib/SOAP/WSDL/Transport/Test.pm \
	lib/SOAP/WSDL/XSD/Schema/Builtin.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/list.pm \
	lib/SOAP/WSDL/XSD/Typelib/ComplexType.pm \
	lib/SOAP/WSDL/XSD/Typelib/Element.pm \
	lib/SOAP/WSDL/XSD/Typelib/SimpleType.pm \
	tmp.pl

# Where is the Config information that we are using/depend on
CONFIGDEP = $(PERL_ARCHLIB)$(DFSEP)Config.pm $(PERL_INC)$(DFSEP)config.h

# Where to build things
INST_LIBDIR      = $(INST_LIB)/SOAP
INST_ARCHLIBDIR  = $(INST_ARCHLIB)/SOAP

INST_AUTODIR     = $(INST_LIB)/auto/$(FULLEXT)
INST_ARCHAUTODIR = $(INST_ARCHLIB)/auto/$(FULLEXT)

INST_STATIC      = 
INST_DYNAMIC     = 
INST_BOOT        = 

# Extra linker info
EXPORT_LIST        = 
PERL_ARCHIVE       = 
PERL_ARCHIVE_AFTER = 


TO_INST_PM = lib/SOAP/WSDL.pm \
	lib/SOAP/WSDL/Base.pm \
	lib/SOAP/WSDL/Binding.pm \
	lib/SOAP/WSDL/Client.pm \
	lib/SOAP/WSDL/Client/Base.pm \
	lib/SOAP/WSDL/Definitions.pm \
	lib/SOAP/WSDL/Deserializer/Hash.pm \
	lib/SOAP/WSDL/Deserializer/SOM.pm \
	lib/SOAP/WSDL/Deserializer/XSD.pm \
	lib/SOAP/WSDL/Expat/Base.pm \
	lib/SOAP/WSDL/Expat/Message2Hash.pm \
	lib/SOAP/WSDL/Expat/MessageParser.pm \
	lib/SOAP/WSDL/Expat/MessageStreamParser.pm \
	lib/SOAP/WSDL/Expat/WSDLParser.pm \
	lib/SOAP/WSDL/Factory/Deserializer.pm \
	lib/SOAP/WSDL/Factory/Generator.pm \
	lib/SOAP/WSDL/Factory/Serializer.pm \
	lib/SOAP/WSDL/Factory/Transport.pm \
	lib/SOAP/WSDL/Generator/Iterator/WSDL11.pm \
	lib/SOAP/WSDL/Generator/PrefixResolver.pm \
	lib/SOAP/WSDL/Generator/Template.pm \
	lib/SOAP/WSDL/Generator/Template/Plugin/XSD.pm \
	lib/SOAP/WSDL/Generator/Template/XSD.pm \
	lib/SOAP/WSDL/Generator/Template/XSD/Interface.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/Interface/Body.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/Interface/Header.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/Interface/Operation.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/Interface/POD/Element.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/Interface/POD/Message.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/Interface/POD/Operation.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/Interface/POD/Part.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/Interface/POD/Type.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/Interface/POD/method_info.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/POD/annotation.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/Server.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/Server/POD/Message.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/Server/POD/Operation.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/Server/POD/OutPart.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/Server/POD/method_info.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/Typemap.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/attribute.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/all.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/attributeSet.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/choice.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/complexContent.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/content_model.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/restriction.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/simpleContent.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/simpleContent/extension.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/simpleContent/restriction.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/structure.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/structure/restriction.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/structure/simpleContent.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/all.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/atomicTypes.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/attributeSet.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/complexContent.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/contentModel.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/extension.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/restriction.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/simpleContent.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/simpleContent/extension.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/variety.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/element.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/element/POD/contentModel.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/element/POD/structure.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/simpleType.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/simpleType/POD/contentModel.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/simpleType/POD/list.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/simpleType/POD/restriction.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/simpleType/POD/structure.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/simpleType/POD/union.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/simpleType/atomicType.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/simpleType/contentModel.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/simpleType/list.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/simpleType/restriction.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/simpleType/union.tt \
	lib/SOAP/WSDL/Generator/Visitor.pm \
	lib/SOAP/WSDL/Generator/Visitor/Typemap.pm \
	lib/SOAP/WSDL/Manual.pod \
	lib/SOAP/WSDL/Manual/CodeFirst.pod \
	lib/SOAP/WSDL/Manual/Cookbook.pod \
	lib/SOAP/WSDL/Manual/Deserializer.pod \
	lib/SOAP/WSDL/Manual/FAQ.pod \
	lib/SOAP/WSDL/Manual/Glossary.pod \
	lib/SOAP/WSDL/Manual/Parser.pod \
	lib/SOAP/WSDL/Manual/Serializer.pod \
	lib/SOAP/WSDL/Manual/WS_I.pod \
	lib/SOAP/WSDL/Manual/XSD.pod \
	lib/SOAP/WSDL/Message.pm \
	lib/SOAP/WSDL/OpMessage.pm \
	lib/SOAP/WSDL/Operation.pm \
	lib/SOAP/WSDL/Part.pm \
	lib/SOAP/WSDL/Port.pm \
	lib/SOAP/WSDL/PortType.pm \
	lib/SOAP/WSDL/SOAP/Address.pm \
	lib/SOAP/WSDL/SOAP/Body.pm \
	lib/SOAP/WSDL/SOAP/Header.pm \
	lib/SOAP/WSDL/SOAP/HeaderFault.pm \
	lib/SOAP/WSDL/SOAP/Operation.pm \
	lib/SOAP/WSDL/SOAP/Typelib/Fault.pm \
	lib/SOAP/WSDL/SOAP/Typelib/Fault11.pm \
	lib/SOAP/WSDL/Serializer/XSD.pm \
	lib/SOAP/WSDL/Server.pm \
	lib/SOAP/WSDL/Server/CGI.pm \
	lib/SOAP/WSDL/Server/Mod_Perl2.pm \
	lib/SOAP/WSDL/Server/Simple.pm \
	lib/SOAP/WSDL/Service.pm \
	lib/SOAP/WSDL/Transport/HTTP.pm \
	lib/SOAP/WSDL/Transport/Loopback.pm \
	lib/SOAP/WSDL/Transport/Test.pm \
	lib/SOAP/WSDL/TypeLookup.pm \
	lib/SOAP/WSDL/Types.pm \
	lib/SOAP/WSDL/XSD/Annotation.pm \
	lib/SOAP/WSDL/XSD/Attribute.pm \
	lib/SOAP/WSDL/XSD/AttributeGroup.pm \
	lib/SOAP/WSDL/XSD/Builtin.pm \
	lib/SOAP/WSDL/XSD/ComplexType.pm \
	lib/SOAP/WSDL/XSD/Element.pm \
	lib/SOAP/WSDL/XSD/Enumeration.pm \
	lib/SOAP/WSDL/XSD/FractionDigits.pm \
	lib/SOAP/WSDL/XSD/Group.pm \
	lib/SOAP/WSDL/XSD/Length.pm \
	lib/SOAP/WSDL/XSD/MaxExclusive.pm \
	lib/SOAP/WSDL/XSD/MaxInclusive.pm \
	lib/SOAP/WSDL/XSD/MaxLength.pm \
	lib/SOAP/WSDL/XSD/MinExclusive.pm \
	lib/SOAP/WSDL/XSD/MinInclusive.pm \
	lib/SOAP/WSDL/XSD/MinLength.pm \
	lib/SOAP/WSDL/XSD/Pattern.pm \
	lib/SOAP/WSDL/XSD/Schema.pm \
	lib/SOAP/WSDL/XSD/Schema/Builtin.pm \
	lib/SOAP/WSDL/XSD/SimpleType.pm \
	lib/SOAP/WSDL/XSD/TotalDigits.pm \
	lib/SOAP/WSDL/XSD/Typelib/Attribute.pm \
	lib/SOAP/WSDL/XSD/Typelib/AttributeSet.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/ENTITY.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/ID.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/IDREF.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/IDREFS.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/NCName.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/NMTOKEN.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/NMTOKENS.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/NOTATION.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/Name.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/QName.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/anySimpleType.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/anyType.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/anyURI.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/base64Binary.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/boolean.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/byte.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/date.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/dateTime.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/decimal.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/double.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/duration.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/float.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/gDay.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/gMonth.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/gMonthDay.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/gYear.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/gYearMonth.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/hexBinary.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/int.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/integer.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/language.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/list.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/long.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/negativeInteger.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/nonNegativeInteger.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/nonPositiveInteger.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/normalizedString.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/positiveInteger.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/short.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/string.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/time.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/token.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/unsignedByte.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/unsignedInt.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/unsignedLong.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/unsignedShort.pm \
	lib/SOAP/WSDL/XSD/Typelib/ComplexType.pm \
	lib/SOAP/WSDL/XSD/Typelib/Element.pm \
	lib/SOAP/WSDL/XSD/Typelib/SimpleType.pm \
	lib/SOAP/WSDL/XSD/WhiteSpace.pm \
	test_html.pl \
	tmp.pl

PM_TO_BLIB = lib/SOAP/WSDL.pm \
	blib/lib/SOAP/WSDL.pm \
	lib/SOAP/WSDL/Base.pm \
	blib/lib/SOAP/WSDL/Base.pm \
	lib/SOAP/WSDL/Binding.pm \
	blib/lib/SOAP/WSDL/Binding.pm \
	lib/SOAP/WSDL/Client.pm \
	blib/lib/SOAP/WSDL/Client.pm \
	lib/SOAP/WSDL/Client/Base.pm \
	blib/lib/SOAP/WSDL/Client/Base.pm \
	lib/SOAP/WSDL/Definitions.pm \
	blib/lib/SOAP/WSDL/Definitions.pm \
	lib/SOAP/WSDL/Deserializer/Hash.pm \
	blib/lib/SOAP/WSDL/Deserializer/Hash.pm \
	lib/SOAP/WSDL/Deserializer/SOM.pm \
	blib/lib/SOAP/WSDL/Deserializer/SOM.pm \
	lib/SOAP/WSDL/Deserializer/XSD.pm \
	blib/lib/SOAP/WSDL/Deserializer/XSD.pm \
	lib/SOAP/WSDL/Expat/Base.pm \
	blib/lib/SOAP/WSDL/Expat/Base.pm \
	lib/SOAP/WSDL/Expat/Message2Hash.pm \
	blib/lib/SOAP/WSDL/Expat/Message2Hash.pm \
	lib/SOAP/WSDL/Expat/MessageParser.pm \
	blib/lib/SOAP/WSDL/Expat/MessageParser.pm \
	lib/SOAP/WSDL/Expat/MessageStreamParser.pm \
	blib/lib/SOAP/WSDL/Expat/MessageStreamParser.pm \
	lib/SOAP/WSDL/Expat/WSDLParser.pm \
	blib/lib/SOAP/WSDL/Expat/WSDLParser.pm \
	lib/SOAP/WSDL/Factory/Deserializer.pm \
	blib/lib/SOAP/WSDL/Factory/Deserializer.pm \
	lib/SOAP/WSDL/Factory/Generator.pm \
	blib/lib/SOAP/WSDL/Factory/Generator.pm \
	lib/SOAP/WSDL/Factory/Serializer.pm \
	blib/lib/SOAP/WSDL/Factory/Serializer.pm \
	lib/SOAP/WSDL/Factory/Transport.pm \
	blib/lib/SOAP/WSDL/Factory/Transport.pm \
	lib/SOAP/WSDL/Generator/Iterator/WSDL11.pm \
	blib/lib/SOAP/WSDL/Generator/Iterator/WSDL11.pm \
	lib/SOAP/WSDL/Generator/PrefixResolver.pm \
	blib/lib/SOAP/WSDL/Generator/PrefixResolver.pm \
	lib/SOAP/WSDL/Generator/Template.pm \
	blib/lib/SOAP/WSDL/Generator/Template.pm \
	lib/SOAP/WSDL/Generator/Template/Plugin/XSD.pm \
	blib/lib/SOAP/WSDL/Generator/Template/Plugin/XSD.pm \
	lib/SOAP/WSDL/Generator/Template/XSD.pm \
	blib/lib/SOAP/WSDL/Generator/Template/XSD.pm \
	lib/SOAP/WSDL/Generator/Template/XSD/Interface.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/Interface.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/Interface/Body.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/Interface/Body.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/Interface/Header.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/Interface/Header.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/Interface/Operation.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/Interface/Operation.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/Interface/POD/Element.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/Interface/POD/Element.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/Interface/POD/Message.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/Interface/POD/Message.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/Interface/POD/Operation.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/Interface/POD/Operation.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/Interface/POD/Part.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/Interface/POD/Part.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/Interface/POD/Type.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/Interface/POD/Type.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/Interface/POD/method_info.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/Interface/POD/method_info.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/POD/annotation.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/POD/annotation.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/Server.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/Server.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/Server/POD/Message.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/Server/POD/Message.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/Server/POD/Operation.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/Server/POD/Operation.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/Server/POD/OutPart.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/Server/POD/OutPart.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/Server/POD/method_info.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/Server/POD/method_info.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/Typemap.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/Typemap.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/attribute.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/attribute.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/all.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/all.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/attributeSet.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/attributeSet.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/choice.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/choice.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/complexContent.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/complexContent.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/content_model.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/content_model.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/restriction.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/restriction.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/simpleContent.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/simpleContent.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/simpleContent/extension.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/simpleContent/extension.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/simpleContent/restriction.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/simpleContent/restriction.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/structure.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/structure.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/structure/restriction.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/structure/restriction.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/structure/simpleContent.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/structure/simpleContent.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/all.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/all.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/atomicTypes.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/atomicTypes.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/attributeSet.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/attributeSet.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/complexContent.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/complexContent.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/contentModel.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/contentModel.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/extension.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/extension.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/restriction.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/restriction.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/simpleContent.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/simpleContent.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/simpleContent/extension.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/simpleContent/extension.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/complexType/variety.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/variety.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/element.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/element.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/element/POD/contentModel.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/element/POD/contentModel.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/element/POD/structure.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/element/POD/structure.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/simpleType.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/simpleType.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/simpleType/POD/contentModel.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/simpleType/POD/contentModel.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/simpleType/POD/list.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/simpleType/POD/list.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/simpleType/POD/restriction.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/simpleType/POD/restriction.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/simpleType/POD/structure.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/simpleType/POD/structure.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/simpleType/POD/union.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/simpleType/POD/union.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/simpleType/atomicType.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/simpleType/atomicType.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/simpleType/contentModel.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/simpleType/contentModel.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/simpleType/list.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/simpleType/list.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/simpleType/restriction.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/simpleType/restriction.tt \
	lib/SOAP/WSDL/Generator/Template/XSD/simpleType/union.tt \
	blib/lib/SOAP/WSDL/Generator/Template/XSD/simpleType/union.tt \
	lib/SOAP/WSDL/Generator/Visitor.pm \
	blib/lib/SOAP/WSDL/Generator/Visitor.pm \
	lib/SOAP/WSDL/Generator/Visitor/Typemap.pm \
	blib/lib/SOAP/WSDL/Generator/Visitor/Typemap.pm \
	lib/SOAP/WSDL/Manual.pod \
	blib/lib/SOAP/WSDL/Manual.pod \
	lib/SOAP/WSDL/Manual/CodeFirst.pod \
	blib/lib/SOAP/WSDL/Manual/CodeFirst.pod \
	lib/SOAP/WSDL/Manual/Cookbook.pod \
	blib/lib/SOAP/WSDL/Manual/Cookbook.pod \
	lib/SOAP/WSDL/Manual/Deserializer.pod \
	blib/lib/SOAP/WSDL/Manual/Deserializer.pod \
	lib/SOAP/WSDL/Manual/FAQ.pod \
	blib/lib/SOAP/WSDL/Manual/FAQ.pod \
	lib/SOAP/WSDL/Manual/Glossary.pod \
	blib/lib/SOAP/WSDL/Manual/Glossary.pod \
	lib/SOAP/WSDL/Manual/Parser.pod \
	blib/lib/SOAP/WSDL/Manual/Parser.pod \
	lib/SOAP/WSDL/Manual/Serializer.pod \
	blib/lib/SOAP/WSDL/Manual/Serializer.pod \
	lib/SOAP/WSDL/Manual/WS_I.pod \
	blib/lib/SOAP/WSDL/Manual/WS_I.pod \
	lib/SOAP/WSDL/Manual/XSD.pod \
	blib/lib/SOAP/WSDL/Manual/XSD.pod \
	lib/SOAP/WSDL/Message.pm \
	blib/lib/SOAP/WSDL/Message.pm \
	lib/SOAP/WSDL/OpMessage.pm \
	blib/lib/SOAP/WSDL/OpMessage.pm \
	lib/SOAP/WSDL/Operation.pm \
	blib/lib/SOAP/WSDL/Operation.pm \
	lib/SOAP/WSDL/Part.pm \
	blib/lib/SOAP/WSDL/Part.pm \
	lib/SOAP/WSDL/Port.pm \
	blib/lib/SOAP/WSDL/Port.pm \
	lib/SOAP/WSDL/PortType.pm \
	blib/lib/SOAP/WSDL/PortType.pm \
	lib/SOAP/WSDL/SOAP/Address.pm \
	blib/lib/SOAP/WSDL/SOAP/Address.pm \
	lib/SOAP/WSDL/SOAP/Body.pm \
	blib/lib/SOAP/WSDL/SOAP/Body.pm \
	lib/SOAP/WSDL/SOAP/Header.pm \
	blib/lib/SOAP/WSDL/SOAP/Header.pm \
	lib/SOAP/WSDL/SOAP/HeaderFault.pm \
	blib/lib/SOAP/WSDL/SOAP/HeaderFault.pm \
	lib/SOAP/WSDL/SOAP/Operation.pm \
	blib/lib/SOAP/WSDL/SOAP/Operation.pm \
	lib/SOAP/WSDL/SOAP/Typelib/Fault.pm \
	blib/lib/SOAP/WSDL/SOAP/Typelib/Fault.pm \
	lib/SOAP/WSDL/SOAP/Typelib/Fault11.pm \
	blib/lib/SOAP/WSDL/SOAP/Typelib/Fault11.pm \
	lib/SOAP/WSDL/Serializer/XSD.pm \
	blib/lib/SOAP/WSDL/Serializer/XSD.pm \
	lib/SOAP/WSDL/Server.pm \
	blib/lib/SOAP/WSDL/Server.pm \
	lib/SOAP/WSDL/Server/CGI.pm \
	blib/lib/SOAP/WSDL/Server/CGI.pm \
	lib/SOAP/WSDL/Server/Mod_Perl2.pm \
	blib/lib/SOAP/WSDL/Server/Mod_Perl2.pm \
	lib/SOAP/WSDL/Server/Simple.pm \
	blib/lib/SOAP/WSDL/Server/Simple.pm \
	lib/SOAP/WSDL/Service.pm \
	blib/lib/SOAP/WSDL/Service.pm \
	lib/SOAP/WSDL/Transport/HTTP.pm \
	blib/lib/SOAP/WSDL/Transport/HTTP.pm \
	lib/SOAP/WSDL/Transport/Loopback.pm \
	blib/lib/SOAP/WSDL/Transport/Loopback.pm \
	lib/SOAP/WSDL/Transport/Test.pm \
	blib/lib/SOAP/WSDL/Transport/Test.pm \
	lib/SOAP/WSDL/TypeLookup.pm \
	blib/lib/SOAP/WSDL/TypeLookup.pm \
	lib/SOAP/WSDL/Types.pm \
	blib/lib/SOAP/WSDL/Types.pm \
	lib/SOAP/WSDL/XSD/Annotation.pm \
	blib/lib/SOAP/WSDL/XSD/Annotation.pm \
	lib/SOAP/WSDL/XSD/Attribute.pm \
	blib/lib/SOAP/WSDL/XSD/Attribute.pm \
	lib/SOAP/WSDL/XSD/AttributeGroup.pm \
	blib/lib/SOAP/WSDL/XSD/AttributeGroup.pm \
	lib/SOAP/WSDL/XSD/Builtin.pm \
	blib/lib/SOAP/WSDL/XSD/Builtin.pm \
	lib/SOAP/WSDL/XSD/ComplexType.pm \
	blib/lib/SOAP/WSDL/XSD/ComplexType.pm \
	lib/SOAP/WSDL/XSD/Element.pm \
	blib/lib/SOAP/WSDL/XSD/Element.pm \
	lib/SOAP/WSDL/XSD/Enumeration.pm \
	blib/lib/SOAP/WSDL/XSD/Enumeration.pm \
	lib/SOAP/WSDL/XSD/FractionDigits.pm \
	blib/lib/SOAP/WSDL/XSD/FractionDigits.pm \
	lib/SOAP/WSDL/XSD/Group.pm \
	blib/lib/SOAP/WSDL/XSD/Group.pm \
	lib/SOAP/WSDL/XSD/Length.pm \
	blib/lib/SOAP/WSDL/XSD/Length.pm \
	lib/SOAP/WSDL/XSD/MaxExclusive.pm \
	blib/lib/SOAP/WSDL/XSD/MaxExclusive.pm \
	lib/SOAP/WSDL/XSD/MaxInclusive.pm \
	blib/lib/SOAP/WSDL/XSD/MaxInclusive.pm \
	lib/SOAP/WSDL/XSD/MaxLength.pm \
	blib/lib/SOAP/WSDL/XSD/MaxLength.pm \
	lib/SOAP/WSDL/XSD/MinExclusive.pm \
	blib/lib/SOAP/WSDL/XSD/MinExclusive.pm \
	lib/SOAP/WSDL/XSD/MinInclusive.pm \
	blib/lib/SOAP/WSDL/XSD/MinInclusive.pm \
	lib/SOAP/WSDL/XSD/MinLength.pm \
	blib/lib/SOAP/WSDL/XSD/MinLength.pm \
	lib/SOAP/WSDL/XSD/Pattern.pm \
	blib/lib/SOAP/WSDL/XSD/Pattern.pm \
	lib/SOAP/WSDL/XSD/Schema.pm \
	blib/lib/SOAP/WSDL/XSD/Schema.pm \
	lib/SOAP/WSDL/XSD/Schema/Builtin.pm \
	blib/lib/SOAP/WSDL/XSD/Schema/Builtin.pm \
	lib/SOAP/WSDL/XSD/SimpleType.pm \
	blib/lib/SOAP/WSDL/XSD/SimpleType.pm \
	lib/SOAP/WSDL/XSD/TotalDigits.pm \
	blib/lib/SOAP/WSDL/XSD/TotalDigits.pm \
	lib/SOAP/WSDL/XSD/Typelib/Attribute.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Attribute.pm \
	lib/SOAP/WSDL/XSD/Typelib/AttributeSet.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/AttributeSet.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/ENTITY.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/ENTITY.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/ID.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/ID.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/IDREF.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/IDREF.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/IDREFS.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/IDREFS.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/NCName.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/NCName.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/NMTOKEN.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/NMTOKEN.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/NMTOKENS.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/NMTOKENS.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/NOTATION.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/NOTATION.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/Name.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/Name.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/QName.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/QName.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/anySimpleType.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/anySimpleType.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/anyType.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/anyType.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/anyURI.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/anyURI.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/base64Binary.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/base64Binary.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/boolean.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/boolean.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/byte.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/byte.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/date.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/date.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/dateTime.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/dateTime.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/decimal.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/decimal.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/double.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/double.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/duration.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/duration.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/float.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/float.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/gDay.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/gDay.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/gMonth.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/gMonth.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/gMonthDay.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/gMonthDay.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/gYear.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/gYear.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/gYearMonth.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/gYearMonth.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/hexBinary.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/hexBinary.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/int.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/int.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/integer.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/integer.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/language.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/language.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/list.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/list.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/long.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/long.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/negativeInteger.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/negativeInteger.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/nonNegativeInteger.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/nonNegativeInteger.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/nonPositiveInteger.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/nonPositiveInteger.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/normalizedString.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/normalizedString.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/positiveInteger.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/positiveInteger.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/short.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/short.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/string.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/string.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/time.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/time.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/token.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/token.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/unsignedByte.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/unsignedByte.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/unsignedInt.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/unsignedInt.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/unsignedLong.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/unsignedLong.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/unsignedShort.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/unsignedShort.pm \
	lib/SOAP/WSDL/XSD/Typelib/ComplexType.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/ComplexType.pm \
	lib/SOAP/WSDL/XSD/Typelib/Element.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/Element.pm \
	lib/SOAP/WSDL/XSD/Typelib/SimpleType.pm \
	blib/lib/SOAP/WSDL/XSD/Typelib/SimpleType.pm \
	lib/SOAP/WSDL/XSD/WhiteSpace.pm \
	blib/lib/SOAP/WSDL/XSD/WhiteSpace.pm \
	test_html.pl \
	$(INST_LIB)/SOAP/test_html.pl \
	tmp.pl \
	$(INST_LIB)/SOAP/tmp.pl


# --- MakeMaker platform_constants section:
MM_Unix_VERSION = 6.88
PERL_MALLOC_DEF = -DPERL_EXTMALLOC_DEF -Dmalloc=Perl_malloc -Dfree=Perl_mfree -Drealloc=Perl_realloc -Dcalloc=Perl_calloc


# --- MakeMaker tool_autosplit section:
# Usage: $(AUTOSPLITFILE) FileToSplit AutoDirToSplitInto
AUTOSPLITFILE = $(ABSPERLRUN)  -e 'use AutoSplit;  autosplit($$$$ARGV[0], $$$$ARGV[1], 0, 1, 1)' --



# --- MakeMaker tool_xsubpp section:


# --- MakeMaker tools_other section:
SHELL = /bin/sh
CHMOD = chmod
CP = cp
MV = mv
NOOP = $(TRUE)
NOECHO = @
RM_F = rm -f
RM_RF = rm -rf
TEST_F = test -f
TOUCH = touch
UMASK_NULL = umask 0
DEV_NULL = > /dev/null 2>&1
MKPATH = $(ABSPERLRUN) -MExtUtils::Command -e 'mkpath' --
EQUALIZE_TIMESTAMP = $(ABSPERLRUN) -MExtUtils::Command -e 'eqtime' --
FALSE = false
TRUE = true
ECHO = echo
ECHO_N = echo -n
UNINST = 0
VERBINST = 0
MOD_INSTALL = $(ABSPERLRUN) -MExtUtils::Install -e 'install([ from_to => {@ARGV}, verbose => '\''$(VERBINST)'\'', uninstall_shadows => '\''$(UNINST)'\'', dir_mode => '\''$(PERM_DIR)'\'' ]);' --
DOC_INSTALL = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'perllocal_install' --
UNINSTALL = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'uninstall' --
WARN_IF_OLD_PACKLIST = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'warn_if_old_packlist' --
MACROSTART = 
MACROEND = 
USEMAKEFILE = -f
FIXIN = $(ABSPERLRUN) -MExtUtils::MY -e 'MY->fixin(shift)' --
CP_NONEMPTY = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'cp_nonempty' --


# --- MakeMaker makemakerdflt section:
makemakerdflt : all
	$(NOECHO) $(NOOP)


# --- MakeMaker dist section:
TAR = tar
TARFLAGS = cvf
ZIP = zip
ZIPFLAGS = -r
COMPRESS = gzip --best
SUFFIX = .gz
SHAR = shar
PREOP = $(NOECHO) $(NOOP)
POSTOP = $(NOECHO) $(NOOP)
TO_UNIX = $(NOECHO) $(NOOP)
CI = ci -u
RCS_LABEL = rcs -Nv$(VERSION_SYM): -q
DIST_CP = best
DIST_DEFAULT = tardist
DISTNAME = SOAP-WSDL
DISTVNAME = SOAP-WSDL-3.00.0_2


# --- MakeMaker macro section:


# --- MakeMaker depend section:


# --- MakeMaker cflags section:


# --- MakeMaker const_loadlibs section:


# --- MakeMaker const_cccmd section:


# --- MakeMaker post_constants section:


# --- MakeMaker pasthru section:

PASTHRU = LIBPERL_A="$(LIBPERL_A)"\
	LINKTYPE="$(LINKTYPE)"\
	PREFIX="$(PREFIX)"


# --- MakeMaker special_targets section:
.SUFFIXES : .xs .c .C .cpp .i .s .cxx .cc $(OBJ_EXT)

.PHONY: all config static dynamic test linkext manifest blibdirs clean realclean disttest distdir



# --- MakeMaker c_o section:


# --- MakeMaker xs_c section:


# --- MakeMaker xs_o section:


# --- MakeMaker top_targets section:
all :: pure_all manifypods
	$(NOECHO) $(NOOP)


pure_all :: config pm_to_blib subdirs linkext
	$(NOECHO) $(NOOP)

subdirs :: $(MYEXTLIB)
	$(NOECHO) $(NOOP)

config :: $(FIRST_MAKEFILE) blibdirs
	$(NOECHO) $(NOOP)

help :
	perldoc ExtUtils::MakeMaker


# --- MakeMaker blibdirs section:
blibdirs : $(INST_LIBDIR)$(DFSEP).exists $(INST_ARCHLIB)$(DFSEP).exists $(INST_AUTODIR)$(DFSEP).exists $(INST_ARCHAUTODIR)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists $(INST_SCRIPT)$(DFSEP).exists $(INST_MAN1DIR)$(DFSEP).exists $(INST_MAN3DIR)$(DFSEP).exists
	$(NOECHO) $(NOOP)

# Backwards compat with 6.18 through 6.25
blibdirs.ts : blibdirs
	$(NOECHO) $(NOOP)

$(INST_LIBDIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_LIBDIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_LIBDIR)
	$(NOECHO) $(TOUCH) $(INST_LIBDIR)$(DFSEP).exists

$(INST_ARCHLIB)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_ARCHLIB)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_ARCHLIB)
	$(NOECHO) $(TOUCH) $(INST_ARCHLIB)$(DFSEP).exists

$(INST_AUTODIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_AUTODIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_AUTODIR)
	$(NOECHO) $(TOUCH) $(INST_AUTODIR)$(DFSEP).exists

$(INST_ARCHAUTODIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_ARCHAUTODIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_ARCHAUTODIR)
	$(NOECHO) $(TOUCH) $(INST_ARCHAUTODIR)$(DFSEP).exists

$(INST_BIN)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_BIN)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_BIN)
	$(NOECHO) $(TOUCH) $(INST_BIN)$(DFSEP).exists

$(INST_SCRIPT)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_SCRIPT)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_SCRIPT)
	$(NOECHO) $(TOUCH) $(INST_SCRIPT)$(DFSEP).exists

$(INST_MAN1DIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_MAN1DIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_MAN1DIR)
	$(NOECHO) $(TOUCH) $(INST_MAN1DIR)$(DFSEP).exists

$(INST_MAN3DIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_MAN3DIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_MAN3DIR)
	$(NOECHO) $(TOUCH) $(INST_MAN3DIR)$(DFSEP).exists



# --- MakeMaker linkext section:

linkext :: $(LINKTYPE)
	$(NOECHO) $(NOOP)


# --- MakeMaker dlsyms section:


# --- MakeMaker dynamic_bs section:

BOOTSTRAP =


# --- MakeMaker dynamic section:

dynamic :: $(FIRST_MAKEFILE) $(BOOTSTRAP) $(INST_DYNAMIC)
	$(NOECHO) $(NOOP)


# --- MakeMaker dynamic_lib section:


# --- MakeMaker static section:

## $(INST_PM) has been moved to the all: target.
## It remains here for awhile to allow for old usage: "make static"
static :: $(FIRST_MAKEFILE) $(INST_STATIC)
	$(NOECHO) $(NOOP)


# --- MakeMaker static_lib section:


# --- MakeMaker manifypods section:

POD2MAN_EXE = $(PERLRUN) "-MExtUtils::Command::MM" -e pod2man "--"
POD2MAN = $(POD2MAN_EXE)


manifypods : pure_all  \
	lib/SOAP/WSDL.pm \
	lib/SOAP/WSDL/Client.pm \
	lib/SOAP/WSDL/Client/Base.pm \
	lib/SOAP/WSDL/Definitions.pm \
	lib/SOAP/WSDL/Deserializer/Hash.pm \
	lib/SOAP/WSDL/Deserializer/SOM.pm \
	lib/SOAP/WSDL/Deserializer/XSD.pm \
	lib/SOAP/WSDL/Expat/Base.pm \
	lib/SOAP/WSDL/Expat/Message2Hash.pm \
	lib/SOAP/WSDL/Expat/MessageParser.pm \
	lib/SOAP/WSDL/Expat/MessageStreamParser.pm \
	lib/SOAP/WSDL/Expat/WSDLParser.pm \
	lib/SOAP/WSDL/Factory/Deserializer.pm \
	lib/SOAP/WSDL/Factory/Generator.pm \
	lib/SOAP/WSDL/Factory/Serializer.pm \
	lib/SOAP/WSDL/Factory/Transport.pm \
	lib/SOAP/WSDL/Generator/Iterator/WSDL11.pm \
	lib/SOAP/WSDL/Generator/PrefixResolver.pm \
	lib/SOAP/WSDL/Generator/Template.pm \
	lib/SOAP/WSDL/Generator/Template/Plugin/XSD.pm \
	lib/SOAP/WSDL/Generator/Template/XSD.pm \
	lib/SOAP/WSDL/Generator/Visitor.pm \
	lib/SOAP/WSDL/Generator/Visitor/Typemap.pm \
	lib/SOAP/WSDL/Manual.pod \
	lib/SOAP/WSDL/Manual/CodeFirst.pod \
	lib/SOAP/WSDL/Manual/Cookbook.pod \
	lib/SOAP/WSDL/Manual/Deserializer.pod \
	lib/SOAP/WSDL/Manual/FAQ.pod \
	lib/SOAP/WSDL/Manual/Glossary.pod \
	lib/SOAP/WSDL/Manual/Parser.pod \
	lib/SOAP/WSDL/Manual/Serializer.pod \
	lib/SOAP/WSDL/Manual/WS_I.pod \
	lib/SOAP/WSDL/Manual/XSD.pod \
	lib/SOAP/WSDL/SOAP/Typelib/Fault11.pm \
	lib/SOAP/WSDL/Serializer/XSD.pm \
	lib/SOAP/WSDL/Server.pm \
	lib/SOAP/WSDL/Server/CGI.pm \
	lib/SOAP/WSDL/Server/Mod_Perl2.pm \
	lib/SOAP/WSDL/Server/Simple.pm \
	lib/SOAP/WSDL/Transport/HTTP.pm \
	lib/SOAP/WSDL/Transport/Loopback.pm \
	lib/SOAP/WSDL/Transport/Test.pm \
	lib/SOAP/WSDL/XSD/Schema/Builtin.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin.pm \
	lib/SOAP/WSDL/XSD/Typelib/Builtin/list.pm \
	lib/SOAP/WSDL/XSD/Typelib/ComplexType.pm \
	lib/SOAP/WSDL/XSD/Typelib/Element.pm \
	lib/SOAP/WSDL/XSD/Typelib/SimpleType.pm \
	tmp.pl
	$(NOECHO) $(POD2MAN) --section=3 --perm_rw=$(PERM_RW) \
	  lib/SOAP/WSDL.pm $(INST_MAN3DIR)/SOAP::WSDL.$(MAN3EXT) \
	  lib/SOAP/WSDL/Client.pm $(INST_MAN3DIR)/SOAP::WSDL::Client.$(MAN3EXT) \
	  lib/SOAP/WSDL/Client/Base.pm $(INST_MAN3DIR)/SOAP::WSDL::Client::Base.$(MAN3EXT) \
	  lib/SOAP/WSDL/Definitions.pm $(INST_MAN3DIR)/SOAP::WSDL::Definitions.$(MAN3EXT) \
	  lib/SOAP/WSDL/Deserializer/Hash.pm $(INST_MAN3DIR)/SOAP::WSDL::Deserializer::Hash.$(MAN3EXT) \
	  lib/SOAP/WSDL/Deserializer/SOM.pm $(INST_MAN3DIR)/SOAP::WSDL::Deserializer::SOM.$(MAN3EXT) \
	  lib/SOAP/WSDL/Deserializer/XSD.pm $(INST_MAN3DIR)/SOAP::WSDL::Deserializer::XSD.$(MAN3EXT) \
	  lib/SOAP/WSDL/Expat/Base.pm $(INST_MAN3DIR)/SOAP::WSDL::Expat::Base.$(MAN3EXT) \
	  lib/SOAP/WSDL/Expat/Message2Hash.pm $(INST_MAN3DIR)/SOAP::WSDL::Expat::Message2Hash.$(MAN3EXT) \
	  lib/SOAP/WSDL/Expat/MessageParser.pm $(INST_MAN3DIR)/SOAP::WSDL::Expat::MessageParser.$(MAN3EXT) \
	  lib/SOAP/WSDL/Expat/MessageStreamParser.pm $(INST_MAN3DIR)/SOAP::WSDL::Expat::MessageStreamParser.$(MAN3EXT) \
	  lib/SOAP/WSDL/Expat/WSDLParser.pm $(INST_MAN3DIR)/SOAP::WSDL::Expat::WSDLParser.$(MAN3EXT) \
	  lib/SOAP/WSDL/Factory/Deserializer.pm $(INST_MAN3DIR)/SOAP::WSDL::Factory::Deserializer.$(MAN3EXT) \
	  lib/SOAP/WSDL/Factory/Generator.pm $(INST_MAN3DIR)/SOAP::WSDL::Factory::Generator.$(MAN3EXT) \
	  lib/SOAP/WSDL/Factory/Serializer.pm $(INST_MAN3DIR)/SOAP::WSDL::Factory::Serializer.$(MAN3EXT) \
	  lib/SOAP/WSDL/Factory/Transport.pm $(INST_MAN3DIR)/SOAP::WSDL::Factory::Transport.$(MAN3EXT) \
	  lib/SOAP/WSDL/Generator/Iterator/WSDL11.pm $(INST_MAN3DIR)/SOAP::WSDL::Generator::Iterator::WSDL11.$(MAN3EXT) \
	  lib/SOAP/WSDL/Generator/PrefixResolver.pm $(INST_MAN3DIR)/SOAP::WSDL::Generator::PrefixResolver.$(MAN3EXT) \
	  lib/SOAP/WSDL/Generator/Template.pm $(INST_MAN3DIR)/SOAP::WSDL::Generator::Template.$(MAN3EXT) \
	  lib/SOAP/WSDL/Generator/Template/Plugin/XSD.pm $(INST_MAN3DIR)/SOAP::WSDL::Generator::Template::Plugin::XSD.$(MAN3EXT) \
	  lib/SOAP/WSDL/Generator/Template/XSD.pm $(INST_MAN3DIR)/SOAP::WSDL::Generator::Template::XSD.$(MAN3EXT) \
	  lib/SOAP/WSDL/Generator/Visitor.pm $(INST_MAN3DIR)/SOAP::WSDL::Generator::Visitor.$(MAN3EXT) \
	  lib/SOAP/WSDL/Generator/Visitor/Typemap.pm $(INST_MAN3DIR)/SOAP::WSDL::Generator::Visitor::Typemap.$(MAN3EXT) \
	  lib/SOAP/WSDL/Manual.pod $(INST_MAN3DIR)/SOAP::WSDL::Manual.$(MAN3EXT) \
	  lib/SOAP/WSDL/Manual/CodeFirst.pod $(INST_MAN3DIR)/SOAP::WSDL::Manual::CodeFirst.$(MAN3EXT) \
	  lib/SOAP/WSDL/Manual/Cookbook.pod $(INST_MAN3DIR)/SOAP::WSDL::Manual::Cookbook.$(MAN3EXT) \
	  lib/SOAP/WSDL/Manual/Deserializer.pod $(INST_MAN3DIR)/SOAP::WSDL::Manual::Deserializer.$(MAN3EXT) \
	  lib/SOAP/WSDL/Manual/FAQ.pod $(INST_MAN3DIR)/SOAP::WSDL::Manual::FAQ.$(MAN3EXT) \
	  lib/SOAP/WSDL/Manual/Glossary.pod $(INST_MAN3DIR)/SOAP::WSDL::Manual::Glossary.$(MAN3EXT) 
	$(NOECHO) $(POD2MAN) --section=3 --perm_rw=$(PERM_RW) \
	  lib/SOAP/WSDL/Manual/Parser.pod $(INST_MAN3DIR)/SOAP::WSDL::Manual::Parser.$(MAN3EXT) \
	  lib/SOAP/WSDL/Manual/Serializer.pod $(INST_MAN3DIR)/SOAP::WSDL::Manual::Serializer.$(MAN3EXT) \
	  lib/SOAP/WSDL/Manual/WS_I.pod $(INST_MAN3DIR)/SOAP::WSDL::Manual::WS_I.$(MAN3EXT) \
	  lib/SOAP/WSDL/Manual/XSD.pod $(INST_MAN3DIR)/SOAP::WSDL::Manual::XSD.$(MAN3EXT) \
	  lib/SOAP/WSDL/SOAP/Typelib/Fault11.pm $(INST_MAN3DIR)/SOAP::WSDL::SOAP::Typelib::Fault11.$(MAN3EXT) \
	  lib/SOAP/WSDL/Serializer/XSD.pm $(INST_MAN3DIR)/SOAP::WSDL::Serializer::XSD.$(MAN3EXT) \
	  lib/SOAP/WSDL/Server.pm $(INST_MAN3DIR)/SOAP::WSDL::Server.$(MAN3EXT) \
	  lib/SOAP/WSDL/Server/CGI.pm $(INST_MAN3DIR)/SOAP::WSDL::Server::CGI.$(MAN3EXT) \
	  lib/SOAP/WSDL/Server/Mod_Perl2.pm $(INST_MAN3DIR)/SOAP::WSDL::Server::Mod_Perl2.$(MAN3EXT) \
	  lib/SOAP/WSDL/Server/Simple.pm $(INST_MAN3DIR)/SOAP::WSDL::Server::Simple.$(MAN3EXT) \
	  lib/SOAP/WSDL/Transport/HTTP.pm $(INST_MAN3DIR)/SOAP::WSDL::Transport::HTTP.$(MAN3EXT) \
	  lib/SOAP/WSDL/Transport/Loopback.pm $(INST_MAN3DIR)/SOAP::WSDL::Transport::Loopback.$(MAN3EXT) \
	  lib/SOAP/WSDL/Transport/Test.pm $(INST_MAN3DIR)/SOAP::WSDL::Transport::Test.$(MAN3EXT) \
	  lib/SOAP/WSDL/XSD/Schema/Builtin.pm $(INST_MAN3DIR)/SOAP::WSDL::XSD::Schema::Builtin.$(MAN3EXT) \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin.pm $(INST_MAN3DIR)/SOAP::WSDL::XSD::Typelib::Builtin.$(MAN3EXT) \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/list.pm $(INST_MAN3DIR)/SOAP::WSDL::XSD::Typelib::Builtin::list.$(MAN3EXT) \
	  lib/SOAP/WSDL/XSD/Typelib/ComplexType.pm $(INST_MAN3DIR)/SOAP::WSDL::XSD::Typelib::ComplexType.$(MAN3EXT) \
	  lib/SOAP/WSDL/XSD/Typelib/Element.pm $(INST_MAN3DIR)/SOAP::WSDL::XSD::Typelib::Element.$(MAN3EXT) \
	  lib/SOAP/WSDL/XSD/Typelib/SimpleType.pm $(INST_MAN3DIR)/SOAP::WSDL::XSD::Typelib::SimpleType.$(MAN3EXT) \
	  tmp.pl $(INST_MAN3DIR)/SOAP::tmp.$(MAN3EXT) 




# --- MakeMaker processPL section:


# --- MakeMaker installbin section:


# --- MakeMaker subdirs section:

# none

# --- MakeMaker clean_subdirs section:
clean_subdirs :
	$(NOECHO) $(NOOP)


# --- MakeMaker clean section:

# Delete temporary files but do not touch installed files. We don't delete
# the Makefile here so a later make realclean still has a makefile to use.

clean :: clean_subdirs
	- $(RM_F) \
	  $(BASEEXT).bso $(BASEEXT).def \
	  $(BASEEXT).exp $(BASEEXT).x \
	  $(BOOTSTRAP) $(INST_ARCHAUTODIR)/extralibs.all \
	  $(INST_ARCHAUTODIR)/extralibs.ld $(MAKE_APERL_FILE) \
	  *$(LIB_EXT) *$(OBJ_EXT) \
	  *perl.core MYMETA.json \
	  MYMETA.yml blibdirs.ts \
	  core core.*perl.*.? \
	  core.[0-9] core.[0-9][0-9] \
	  core.[0-9][0-9][0-9] core.[0-9][0-9][0-9][0-9] \
	  core.[0-9][0-9][0-9][0-9][0-9] lib$(BASEEXT).def \
	  mon.out perl \
	  perl$(EXE_EXT) perl.exe \
	  perlmain.c pm_to_blib \
	  pm_to_blib.ts so_locations \
	  tmon.out 
	- $(RM_RF) \
	  blib 
	  $(NOECHO) $(RM_F) $(MAKEFILE_OLD)
	- $(MV) $(FIRST_MAKEFILE) $(MAKEFILE_OLD) $(DEV_NULL)


# --- MakeMaker realclean_subdirs section:
realclean_subdirs :
	$(NOECHO) $(NOOP)


# --- MakeMaker realclean section:
# Delete temporary files (via clean) and also delete dist files
realclean purge ::  clean realclean_subdirs
	- $(RM_F) \
	  $(MAKEFILE_OLD) $(FIRST_MAKEFILE) 
	- $(RM_RF) \
	  $(DISTVNAME) 


# --- MakeMaker metafile section:
metafile : create_distdir
	$(NOECHO) $(ECHO) Generating META.yml
	$(NOECHO) $(ECHO) '---' > META_new.yml
	$(NOECHO) $(ECHO) 'abstract: '\''SOAP with WSDL support'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'author:' >> META_new.yml
	$(NOECHO) $(ECHO) '  - '\''Scott Walters <scott@slowass.net>'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'build_requires:' >> META_new.yml
	$(NOECHO) $(ECHO) '  ExtUtils::MakeMaker: 0' >> META_new.yml
	$(NOECHO) $(ECHO) 'configure_requires:' >> META_new.yml
	$(NOECHO) $(ECHO) '  ExtUtils::MakeMaker: 0' >> META_new.yml
	$(NOECHO) $(ECHO) 'dynamic_config: 1' >> META_new.yml
	$(NOECHO) $(ECHO) 'generated_by: '\''ExtUtils::MakeMaker version 6.88, CPAN::Meta::Converter version 2.133380'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'license: unknown' >> META_new.yml
	$(NOECHO) $(ECHO) 'meta-spec:' >> META_new.yml
	$(NOECHO) $(ECHO) '  url: http://module-build.sourceforge.net/META-spec-v1.4.html' >> META_new.yml
	$(NOECHO) $(ECHO) '  version: 1.4' >> META_new.yml
	$(NOECHO) $(ECHO) 'name: SOAP-WSDL' >> META_new.yml
	$(NOECHO) $(ECHO) 'no_index:' >> META_new.yml
	$(NOECHO) $(ECHO) '  directory:' >> META_new.yml
	$(NOECHO) $(ECHO) '    - t' >> META_new.yml
	$(NOECHO) $(ECHO) '    - inc' >> META_new.yml
	$(NOECHO) $(ECHO) 'requires:' >> META_new.yml
	$(NOECHO) $(ECHO) '  Class::Std::Fast: 0.000005' >> META_new.yml
	$(NOECHO) $(ECHO) '  Cwd: 0' >> META_new.yml
	$(NOECHO) $(ECHO) '  Data::Dumper: 0' >> META_new.yml
	$(NOECHO) $(ECHO) '  Date::Format: 0' >> META_new.yml
	$(NOECHO) $(ECHO) '  Date::Parse: 0' >> META_new.yml
	$(NOECHO) $(ECHO) '  File::Basename: 0' >> META_new.yml
	$(NOECHO) $(ECHO) '  File::Path: 0' >> META_new.yml
	$(NOECHO) $(ECHO) '  File::Spec: 0' >> META_new.yml
	$(NOECHO) $(ECHO) '  Getopt::Long: 0' >> META_new.yml
	$(NOECHO) $(ECHO) '  LWP::UserAgent: 0' >> META_new.yml
	$(NOECHO) $(ECHO) '  List::Util: 0' >> META_new.yml
	$(NOECHO) $(ECHO) '  Module::Build: 0' >> META_new.yml
	$(NOECHO) $(ECHO) '  Storable: 0' >> META_new.yml
	$(NOECHO) $(ECHO) '  Template: 2.18' >> META_new.yml
	$(NOECHO) $(ECHO) '  Term::ReadKey: 0' >> META_new.yml
	$(NOECHO) $(ECHO) '  Test::More: 0' >> META_new.yml
	$(NOECHO) $(ECHO) '  URI: 0' >> META_new.yml
	$(NOECHO) $(ECHO) '  XML::Parser::Expat: 0' >> META_new.yml
	$(NOECHO) $(ECHO) '  perl: 5.008' >> META_new.yml
	$(NOECHO) $(ECHO) 'version: v3.0.0_2' >> META_new.yml
	-$(NOECHO) $(MV) META_new.yml $(DISTVNAME)/META.yml
	$(NOECHO) $(ECHO) Generating META.json
	$(NOECHO) $(ECHO) '{' > META_new.json
	$(NOECHO) $(ECHO) '   "abstract" : "SOAP with WSDL support",' >> META_new.json
	$(NOECHO) $(ECHO) '   "author" : [' >> META_new.json
	$(NOECHO) $(ECHO) '      "Scott Walters <scott@slowass.net>"' >> META_new.json
	$(NOECHO) $(ECHO) '   ],' >> META_new.json
	$(NOECHO) $(ECHO) '   "dynamic_config" : 1,' >> META_new.json
	$(NOECHO) $(ECHO) '   "generated_by" : "ExtUtils::MakeMaker version 6.88, CPAN::Meta::Converter version 2.133380",' >> META_new.json
	$(NOECHO) $(ECHO) '   "license" : [' >> META_new.json
	$(NOECHO) $(ECHO) '      "unknown"' >> META_new.json
	$(NOECHO) $(ECHO) '   ],' >> META_new.json
	$(NOECHO) $(ECHO) '   "meta-spec" : {' >> META_new.json
	$(NOECHO) $(ECHO) '      "url" : "http://search.cpan.org/perldoc?CPAN::Meta::Spec",' >> META_new.json
	$(NOECHO) $(ECHO) '      "version" : "2"' >> META_new.json
	$(NOECHO) $(ECHO) '   },' >> META_new.json
	$(NOECHO) $(ECHO) '   "name" : "SOAP-WSDL",' >> META_new.json
	$(NOECHO) $(ECHO) '   "no_index" : {' >> META_new.json
	$(NOECHO) $(ECHO) '      "directory" : [' >> META_new.json
	$(NOECHO) $(ECHO) '         "t",' >> META_new.json
	$(NOECHO) $(ECHO) '         "inc"' >> META_new.json
	$(NOECHO) $(ECHO) '      ]' >> META_new.json
	$(NOECHO) $(ECHO) '   },' >> META_new.json
	$(NOECHO) $(ECHO) '   "prereqs" : {' >> META_new.json
	$(NOECHO) $(ECHO) '      "build" : {' >> META_new.json
	$(NOECHO) $(ECHO) '         "requires" : {' >> META_new.json
	$(NOECHO) $(ECHO) '            "ExtUtils::MakeMaker" : "0"' >> META_new.json
	$(NOECHO) $(ECHO) '         }' >> META_new.json
	$(NOECHO) $(ECHO) '      },' >> META_new.json
	$(NOECHO) $(ECHO) '      "configure" : {' >> META_new.json
	$(NOECHO) $(ECHO) '         "requires" : {' >> META_new.json
	$(NOECHO) $(ECHO) '            "ExtUtils::MakeMaker" : "0"' >> META_new.json
	$(NOECHO) $(ECHO) '         }' >> META_new.json
	$(NOECHO) $(ECHO) '      },' >> META_new.json
	$(NOECHO) $(ECHO) '      "runtime" : {' >> META_new.json
	$(NOECHO) $(ECHO) '         "requires" : {' >> META_new.json
	$(NOECHO) $(ECHO) '            "Class::Std::Fast" : "0.000005",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Cwd" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Data::Dumper" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Date::Format" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Date::Parse" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "File::Basename" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "File::Path" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "File::Spec" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Getopt::Long" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "LWP::UserAgent" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "List::Util" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Module::Build" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Storable" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Template" : "2.18",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Term::ReadKey" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "Test::More" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "URI" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "XML::Parser::Expat" : "0",' >> META_new.json
	$(NOECHO) $(ECHO) '            "perl" : "5.008"' >> META_new.json
	$(NOECHO) $(ECHO) '         }' >> META_new.json
	$(NOECHO) $(ECHO) '      }' >> META_new.json
	$(NOECHO) $(ECHO) '   },' >> META_new.json
	$(NOECHO) $(ECHO) '   "release_status" : "testing",' >> META_new.json
	$(NOECHO) $(ECHO) '   "version" : "v3.0.0_2"' >> META_new.json
	$(NOECHO) $(ECHO) '}' >> META_new.json
	-$(NOECHO) $(MV) META_new.json $(DISTVNAME)/META.json


# --- MakeMaker signature section:
signature :
	cpansign -s


# --- MakeMaker dist_basics section:
distclean :: realclean distcheck
	$(NOECHO) $(NOOP)

distcheck :
	$(PERLRUN) "-MExtUtils::Manifest=fullcheck" -e fullcheck

skipcheck :
	$(PERLRUN) "-MExtUtils::Manifest=skipcheck" -e skipcheck

manifest :
	$(PERLRUN) "-MExtUtils::Manifest=mkmanifest" -e mkmanifest

veryclean : realclean
	$(RM_F) *~ */*~ *.orig */*.orig *.bak */*.bak *.old */*.old



# --- MakeMaker dist_core section:

dist : $(DIST_DEFAULT) $(FIRST_MAKEFILE)
	$(NOECHO) $(ABSPERLRUN) -l -e 'print '\''Warning: Makefile possibly out of date with $(VERSION_FROM)'\''' \
	  -e '    if -e '\''$(VERSION_FROM)'\'' and -M '\''$(VERSION_FROM)'\'' < -M '\''$(FIRST_MAKEFILE)'\'';' --

tardist : $(DISTVNAME).tar$(SUFFIX)
	$(NOECHO) $(NOOP)

uutardist : $(DISTVNAME).tar$(SUFFIX)
	uuencode $(DISTVNAME).tar$(SUFFIX) $(DISTVNAME).tar$(SUFFIX) > $(DISTVNAME).tar$(SUFFIX)_uu
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).tar$(SUFFIX)_uu'

$(DISTVNAME).tar$(SUFFIX) : distdir
	$(PREOP)
	$(TO_UNIX)
	$(TAR) $(TARFLAGS) $(DISTVNAME).tar $(DISTVNAME)
	$(RM_RF) $(DISTVNAME)
	$(COMPRESS) $(DISTVNAME).tar
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).tar$(SUFFIX)'
	$(POSTOP)

zipdist : $(DISTVNAME).zip
	$(NOECHO) $(NOOP)

$(DISTVNAME).zip : distdir
	$(PREOP)
	$(ZIP) $(ZIPFLAGS) $(DISTVNAME).zip $(DISTVNAME)
	$(RM_RF) $(DISTVNAME)
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).zip'
	$(POSTOP)

shdist : distdir
	$(PREOP)
	$(SHAR) $(DISTVNAME) > $(DISTVNAME).shar
	$(RM_RF) $(DISTVNAME)
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).shar'
	$(POSTOP)


# --- MakeMaker distdir section:
create_distdir :
	$(RM_RF) $(DISTVNAME)
	$(PERLRUN) "-MExtUtils::Manifest=manicopy,maniread" \
		-e "manicopy(maniread(),'$(DISTVNAME)', '$(DIST_CP)');"

distdir : create_distdir distmeta 
	$(NOECHO) $(NOOP)



# --- MakeMaker dist_test section:
disttest : distdir
	cd $(DISTVNAME) && $(ABSPERLRUN) Makefile.PL 
	cd $(DISTVNAME) && $(MAKE) $(PASTHRU)
	cd $(DISTVNAME) && $(MAKE) test $(PASTHRU)



# --- MakeMaker dist_ci section:

ci :
	$(PERLRUN) "-MExtUtils::Manifest=maniread" \
	  -e "@all = keys %{ maniread() };" \
	  -e "print(qq{Executing $(CI) @all\n}); system(qq{$(CI) @all});" \
	  -e "print(qq{Executing $(RCS_LABEL) ...\n}); system(qq{$(RCS_LABEL) @all});"


# --- MakeMaker distmeta section:
distmeta : create_distdir metafile
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'exit unless -e q{META.yml};' \
	  -e 'eval { maniadd({q{META.yml} => q{Module YAML meta-data (added by MakeMaker)}}) }' \
	  -e '    or print "Could not add META.yml to MANIFEST: $$$${'\''@'\''}\n"' --
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'exit unless -f q{META.json};' \
	  -e 'eval { maniadd({q{META.json} => q{Module JSON meta-data (added by MakeMaker)}}) }' \
	  -e '    or print "Could not add META.json to MANIFEST: $$$${'\''@'\''}\n"' --



# --- MakeMaker distsignature section:
distsignature : create_distdir
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'eval { maniadd({q{SIGNATURE} => q{Public-key signature (added by MakeMaker)}}) }' \
	  -e '    or print "Could not add SIGNATURE to MANIFEST: $$$${'\''@'\''}\n"' --
	$(NOECHO) cd $(DISTVNAME) && $(TOUCH) SIGNATURE
	cd $(DISTVNAME) && cpansign -s



# --- MakeMaker install section:

install :: pure_install doc_install
	$(NOECHO) $(NOOP)

install_perl :: pure_perl_install doc_perl_install
	$(NOECHO) $(NOOP)

install_site :: pure_site_install doc_site_install
	$(NOECHO) $(NOOP)

install_vendor :: pure_vendor_install doc_vendor_install
	$(NOECHO) $(NOOP)

pure_install :: pure_$(INSTALLDIRS)_install
	$(NOECHO) $(NOOP)

doc_install :: doc_$(INSTALLDIRS)_install
	$(NOECHO) $(NOOP)

pure__install : pure_site_install
	$(NOECHO) $(ECHO) INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

doc__install : doc_site_install
	$(NOECHO) $(ECHO) INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

pure_perl_install :: all
	$(NOECHO) $(MOD_INSTALL) \
		read $(PERL_ARCHLIB)/auto/$(FULLEXT)/.packlist \
		write $(DESTINSTALLARCHLIB)/auto/$(FULLEXT)/.packlist \
		$(INST_LIB) $(DESTINSTALLPRIVLIB) \
		$(INST_ARCHLIB) $(DESTINSTALLARCHLIB) \
		$(INST_BIN) $(DESTINSTALLBIN) \
		$(INST_SCRIPT) $(DESTINSTALLSCRIPT) \
		$(INST_MAN1DIR) $(DESTINSTALLMAN1DIR) \
		$(INST_MAN3DIR) $(DESTINSTALLMAN3DIR)
	$(NOECHO) $(WARN_IF_OLD_PACKLIST) \
		$(SITEARCHEXP)/auto/$(FULLEXT)


pure_site_install :: all
	$(NOECHO) $(MOD_INSTALL) \
		read $(SITEARCHEXP)/auto/$(FULLEXT)/.packlist \
		write $(DESTINSTALLSITEARCH)/auto/$(FULLEXT)/.packlist \
		$(INST_LIB) $(DESTINSTALLSITELIB) \
		$(INST_ARCHLIB) $(DESTINSTALLSITEARCH) \
		$(INST_BIN) $(DESTINSTALLSITEBIN) \
		$(INST_SCRIPT) $(DESTINSTALLSITESCRIPT) \
		$(INST_MAN1DIR) $(DESTINSTALLSITEMAN1DIR) \
		$(INST_MAN3DIR) $(DESTINSTALLSITEMAN3DIR)
	$(NOECHO) $(WARN_IF_OLD_PACKLIST) \
		$(PERL_ARCHLIB)/auto/$(FULLEXT)

pure_vendor_install :: all
	$(NOECHO) $(MOD_INSTALL) \
		read $(VENDORARCHEXP)/auto/$(FULLEXT)/.packlist \
		write $(DESTINSTALLVENDORARCH)/auto/$(FULLEXT)/.packlist \
		$(INST_LIB) $(DESTINSTALLVENDORLIB) \
		$(INST_ARCHLIB) $(DESTINSTALLVENDORARCH) \
		$(INST_BIN) $(DESTINSTALLVENDORBIN) \
		$(INST_SCRIPT) $(DESTINSTALLVENDORSCRIPT) \
		$(INST_MAN1DIR) $(DESTINSTALLVENDORMAN1DIR) \
		$(INST_MAN3DIR) $(DESTINSTALLVENDORMAN3DIR)


doc_perl_install :: all
	$(NOECHO) $(ECHO) Appending installation info to $(DESTINSTALLARCHLIB)/perllocal.pod
	-$(NOECHO) $(MKPATH) $(DESTINSTALLARCHLIB)
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLPRIVLIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(DESTINSTALLARCHLIB)/perllocal.pod

doc_site_install :: all
	$(NOECHO) $(ECHO) Appending installation info to $(DESTINSTALLARCHLIB)/perllocal.pod
	-$(NOECHO) $(MKPATH) $(DESTINSTALLARCHLIB)
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLSITELIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(DESTINSTALLARCHLIB)/perllocal.pod

doc_vendor_install :: all
	$(NOECHO) $(ECHO) Appending installation info to $(DESTINSTALLARCHLIB)/perllocal.pod
	-$(NOECHO) $(MKPATH) $(DESTINSTALLARCHLIB)
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLVENDORLIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(DESTINSTALLARCHLIB)/perllocal.pod


uninstall :: uninstall_from_$(INSTALLDIRS)dirs
	$(NOECHO) $(NOOP)

uninstall_from_perldirs ::
	$(NOECHO) $(UNINSTALL) $(PERL_ARCHLIB)/auto/$(FULLEXT)/.packlist

uninstall_from_sitedirs ::
	$(NOECHO) $(UNINSTALL) $(SITEARCHEXP)/auto/$(FULLEXT)/.packlist

uninstall_from_vendordirs ::
	$(NOECHO) $(UNINSTALL) $(VENDORARCHEXP)/auto/$(FULLEXT)/.packlist


# --- MakeMaker force section:
# Phony target to force checking subdirectories.
FORCE :
	$(NOECHO) $(NOOP)


# --- MakeMaker perldepend section:


# --- MakeMaker makefile section:
# We take a very conservative approach here, but it's worth it.
# We move Makefile to Makefile.old here to avoid gnu make looping.
$(FIRST_MAKEFILE) : Makefile.PL $(CONFIGDEP)
	$(NOECHO) $(ECHO) "Makefile out-of-date with respect to $?"
	$(NOECHO) $(ECHO) "Cleaning current config before rebuilding Makefile..."
	-$(NOECHO) $(RM_F) $(MAKEFILE_OLD)
	-$(NOECHO) $(MV)   $(FIRST_MAKEFILE) $(MAKEFILE_OLD)
	- $(MAKE) $(USEMAKEFILE) $(MAKEFILE_OLD) clean $(DEV_NULL)
	$(PERLRUN) Makefile.PL 
	$(NOECHO) $(ECHO) "==> Your Makefile has been rebuilt. <=="
	$(NOECHO) $(ECHO) "==> Please rerun the $(MAKE) command.  <=="
	$(FALSE)



# --- MakeMaker staticmake section:

# --- MakeMaker makeaperl section ---
MAP_TARGET    = perl
FULLPERL      = /usr/local/bin/perl

$(MAP_TARGET) :: static $(MAKE_APERL_FILE)
	$(MAKE) $(USEMAKEFILE) $(MAKE_APERL_FILE) $@

$(MAKE_APERL_FILE) : $(FIRST_MAKEFILE) pm_to_blib
	$(NOECHO) $(ECHO) Writing \"$(MAKE_APERL_FILE)\" for this $(MAP_TARGET)
	$(NOECHO) $(PERLRUNINST) \
		Makefile.PL DIR= \
		MAKEFILE=$(MAKE_APERL_FILE) LINKTYPE=static \
		MAKEAPERL=1 NORECURS=1 CCCDLFLAGS=


# --- MakeMaker test section:

TEST_VERBOSE=0
TEST_TYPE=test_$(LINKTYPE)
TEST_FILE = test.pl
TEST_FILES = t/*.t t/*/*.t t/*/*/*.t t/*/*/*/*.t t/*/*/*/*/*.t t/*/*/*/*/*/*.t
TESTDB_SW = -d

testdb :: testdb_$(LINKTYPE)

test :: $(TEST_TYPE) subdirs-test

subdirs-test ::
	$(NOECHO) $(NOOP)


test_dynamic :: pure_all
	PERL_DL_NONLAZY=1 $(FULLPERLRUN) "-MExtUtils::Command::MM" "-MTest::Harness" "-e" "undef *Test::Harness::Switches; test_harness($(TEST_VERBOSE), '$(INST_LIB)', '$(INST_ARCHLIB)')" $(TEST_FILES)

testdb_dynamic :: pure_all
	PERL_DL_NONLAZY=1 $(FULLPERLRUN) $(TESTDB_SW) "-I$(INST_LIB)" "-I$(INST_ARCHLIB)" $(TEST_FILE)

test_ : test_dynamic

test_static :: test_dynamic
testdb_static :: testdb_dynamic


# --- MakeMaker ppd section:
# Creates a PPD (Perl Package Description) for a binary distribution.
ppd :
	$(NOECHO) $(ECHO) '<SOFTPKG NAME="$(DISTNAME)" VERSION="$(VERSION)">' > $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <ABSTRACT>SOAP with WSDL support</ABSTRACT>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <AUTHOR>Scott Walters &lt;scott@slowass.net&gt;</AUTHOR>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <IMPLEMENTATION>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE VERSION="5e-06" NAME="Class::Std::Fast" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Cwd::" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Data::Dumper" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Date::Format" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Date::Parse" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="File::Basename" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="File::Path" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="File::Spec" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Getopt::Long" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="LWP::UserAgent" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="List::Util" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Module::Build" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Storable::" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Template::" VERSION="2.18" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Term::ReadKey" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Test::More" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="URI::" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="XML::Parser::Expat" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <ARCHITECTURE NAME="i686-linux-5.19" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <CODEBASE HREF="" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    </IMPLEMENTATION>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '</SOFTPKG>' >> $(DISTNAME).ppd


# --- MakeMaker pm_to_blib section:

pm_to_blib : $(FIRST_MAKEFILE) $(TO_INST_PM)
	$(NOECHO) $(ABSPERLRUN) -MExtUtils::Install -e 'pm_to_blib({@ARGV}, '\''$(INST_LIB)/auto'\'', q[$(PM_FILTER)], '\''$(PERM_DIR)'\'')' -- \
	  lib/SOAP/WSDL.pm blib/lib/SOAP/WSDL.pm \
	  lib/SOAP/WSDL/Base.pm blib/lib/SOAP/WSDL/Base.pm \
	  lib/SOAP/WSDL/Binding.pm blib/lib/SOAP/WSDL/Binding.pm \
	  lib/SOAP/WSDL/Client.pm blib/lib/SOAP/WSDL/Client.pm \
	  lib/SOAP/WSDL/Client/Base.pm blib/lib/SOAP/WSDL/Client/Base.pm \
	  lib/SOAP/WSDL/Definitions.pm blib/lib/SOAP/WSDL/Definitions.pm \
	  lib/SOAP/WSDL/Deserializer/Hash.pm blib/lib/SOAP/WSDL/Deserializer/Hash.pm \
	  lib/SOAP/WSDL/Deserializer/SOM.pm blib/lib/SOAP/WSDL/Deserializer/SOM.pm \
	  lib/SOAP/WSDL/Deserializer/XSD.pm blib/lib/SOAP/WSDL/Deserializer/XSD.pm \
	  lib/SOAP/WSDL/Expat/Base.pm blib/lib/SOAP/WSDL/Expat/Base.pm \
	  lib/SOAP/WSDL/Expat/Message2Hash.pm blib/lib/SOAP/WSDL/Expat/Message2Hash.pm \
	  lib/SOAP/WSDL/Expat/MessageParser.pm blib/lib/SOAP/WSDL/Expat/MessageParser.pm \
	  lib/SOAP/WSDL/Expat/MessageStreamParser.pm blib/lib/SOAP/WSDL/Expat/MessageStreamParser.pm \
	  lib/SOAP/WSDL/Expat/WSDLParser.pm blib/lib/SOAP/WSDL/Expat/WSDLParser.pm \
	  lib/SOAP/WSDL/Factory/Deserializer.pm blib/lib/SOAP/WSDL/Factory/Deserializer.pm \
	  lib/SOAP/WSDL/Factory/Generator.pm blib/lib/SOAP/WSDL/Factory/Generator.pm \
	  lib/SOAP/WSDL/Factory/Serializer.pm blib/lib/SOAP/WSDL/Factory/Serializer.pm \
	  lib/SOAP/WSDL/Factory/Transport.pm blib/lib/SOAP/WSDL/Factory/Transport.pm \
	  lib/SOAP/WSDL/Generator/Iterator/WSDL11.pm blib/lib/SOAP/WSDL/Generator/Iterator/WSDL11.pm \
	  lib/SOAP/WSDL/Generator/PrefixResolver.pm blib/lib/SOAP/WSDL/Generator/PrefixResolver.pm \
	  lib/SOAP/WSDL/Generator/Template.pm blib/lib/SOAP/WSDL/Generator/Template.pm \
	  lib/SOAP/WSDL/Generator/Template/Plugin/XSD.pm blib/lib/SOAP/WSDL/Generator/Template/Plugin/XSD.pm \
	  lib/SOAP/WSDL/Generator/Template/XSD.pm blib/lib/SOAP/WSDL/Generator/Template/XSD.pm \
	  lib/SOAP/WSDL/Generator/Template/XSD/Interface.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/Interface.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/Interface/Body.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/Interface/Body.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/Interface/Header.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/Interface/Header.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/Interface/Operation.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/Interface/Operation.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/Interface/POD/Element.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/Interface/POD/Element.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/Interface/POD/Message.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/Interface/POD/Message.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/Interface/POD/Operation.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/Interface/POD/Operation.tt 
	$(NOECHO) $(ABSPERLRUN) -MExtUtils::Install -e 'pm_to_blib({@ARGV}, '\''$(INST_LIB)/auto'\'', q[$(PM_FILTER)], '\''$(PERM_DIR)'\'')' -- \
	  lib/SOAP/WSDL/Generator/Template/XSD/Interface/POD/Part.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/Interface/POD/Part.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/Interface/POD/Type.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/Interface/POD/Type.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/Interface/POD/method_info.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/Interface/POD/method_info.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/POD/annotation.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/POD/annotation.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/Server.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/Server.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/Server/POD/Message.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/Server/POD/Message.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/Server/POD/Operation.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/Server/POD/Operation.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/Server/POD/OutPart.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/Server/POD/OutPart.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/Server/POD/method_info.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/Server/POD/method_info.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/Typemap.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/Typemap.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/attribute.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/attribute.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/complexType.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/all.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/all.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/attributeSet.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/attributeSet.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/choice.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/choice.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/complexContent.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/complexContent.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/content_model.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/content_model.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/restriction.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/restriction.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/simpleContent.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/simpleContent.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/simpleContent/extension.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/simpleContent/extension.tt 
	$(NOECHO) $(ABSPERLRUN) -MExtUtils::Install -e 'pm_to_blib({@ARGV}, '\''$(INST_LIB)/auto'\'', q[$(PM_FILTER)], '\''$(PERM_DIR)'\'')' -- \
	  lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/simpleContent/restriction.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/simpleContent/restriction.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/structure.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/structure.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/structure/restriction.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/structure/restriction.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/structure/simpleContent.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/POD/structure/simpleContent.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/complexType/all.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/all.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/complexType/atomicTypes.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/atomicTypes.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/complexType/attributeSet.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/attributeSet.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/complexType/complexContent.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/complexContent.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/complexType/contentModel.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/contentModel.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/complexType/extension.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/extension.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/complexType/restriction.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/restriction.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/complexType/simpleContent.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/simpleContent.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/complexType/simpleContent/extension.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/simpleContent/extension.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/complexType/variety.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/complexType/variety.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/element.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/element.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/element/POD/contentModel.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/element/POD/contentModel.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/element/POD/structure.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/element/POD/structure.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/simpleType.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/simpleType.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/simpleType/POD/contentModel.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/simpleType/POD/contentModel.tt 
	$(NOECHO) $(ABSPERLRUN) -MExtUtils::Install -e 'pm_to_blib({@ARGV}, '\''$(INST_LIB)/auto'\'', q[$(PM_FILTER)], '\''$(PERM_DIR)'\'')' -- \
	  lib/SOAP/WSDL/Generator/Template/XSD/simpleType/POD/list.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/simpleType/POD/list.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/simpleType/POD/restriction.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/simpleType/POD/restriction.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/simpleType/POD/structure.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/simpleType/POD/structure.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/simpleType/POD/union.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/simpleType/POD/union.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/simpleType/atomicType.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/simpleType/atomicType.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/simpleType/contentModel.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/simpleType/contentModel.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/simpleType/list.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/simpleType/list.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/simpleType/restriction.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/simpleType/restriction.tt \
	  lib/SOAP/WSDL/Generator/Template/XSD/simpleType/union.tt blib/lib/SOAP/WSDL/Generator/Template/XSD/simpleType/union.tt \
	  lib/SOAP/WSDL/Generator/Visitor.pm blib/lib/SOAP/WSDL/Generator/Visitor.pm \
	  lib/SOAP/WSDL/Generator/Visitor/Typemap.pm blib/lib/SOAP/WSDL/Generator/Visitor/Typemap.pm \
	  lib/SOAP/WSDL/Manual.pod blib/lib/SOAP/WSDL/Manual.pod \
	  lib/SOAP/WSDL/Manual/CodeFirst.pod blib/lib/SOAP/WSDL/Manual/CodeFirst.pod \
	  lib/SOAP/WSDL/Manual/Cookbook.pod blib/lib/SOAP/WSDL/Manual/Cookbook.pod \
	  lib/SOAP/WSDL/Manual/Deserializer.pod blib/lib/SOAP/WSDL/Manual/Deserializer.pod \
	  lib/SOAP/WSDL/Manual/FAQ.pod blib/lib/SOAP/WSDL/Manual/FAQ.pod \
	  lib/SOAP/WSDL/Manual/Glossary.pod blib/lib/SOAP/WSDL/Manual/Glossary.pod \
	  lib/SOAP/WSDL/Manual/Parser.pod blib/lib/SOAP/WSDL/Manual/Parser.pod \
	  lib/SOAP/WSDL/Manual/Serializer.pod blib/lib/SOAP/WSDL/Manual/Serializer.pod \
	  lib/SOAP/WSDL/Manual/WS_I.pod blib/lib/SOAP/WSDL/Manual/WS_I.pod \
	  lib/SOAP/WSDL/Manual/XSD.pod blib/lib/SOAP/WSDL/Manual/XSD.pod \
	  lib/SOAP/WSDL/Message.pm blib/lib/SOAP/WSDL/Message.pm \
	  lib/SOAP/WSDL/OpMessage.pm blib/lib/SOAP/WSDL/OpMessage.pm \
	  lib/SOAP/WSDL/Operation.pm blib/lib/SOAP/WSDL/Operation.pm \
	  lib/SOAP/WSDL/Part.pm blib/lib/SOAP/WSDL/Part.pm \
	  lib/SOAP/WSDL/Port.pm blib/lib/SOAP/WSDL/Port.pm \
	  lib/SOAP/WSDL/PortType.pm blib/lib/SOAP/WSDL/PortType.pm \
	  lib/SOAP/WSDL/SOAP/Address.pm blib/lib/SOAP/WSDL/SOAP/Address.pm \
	  lib/SOAP/WSDL/SOAP/Body.pm blib/lib/SOAP/WSDL/SOAP/Body.pm \
	  lib/SOAP/WSDL/SOAP/Header.pm blib/lib/SOAP/WSDL/SOAP/Header.pm \
	  lib/SOAP/WSDL/SOAP/HeaderFault.pm blib/lib/SOAP/WSDL/SOAP/HeaderFault.pm 
	$(NOECHO) $(ABSPERLRUN) -MExtUtils::Install -e 'pm_to_blib({@ARGV}, '\''$(INST_LIB)/auto'\'', q[$(PM_FILTER)], '\''$(PERM_DIR)'\'')' -- \
	  lib/SOAP/WSDL/SOAP/Operation.pm blib/lib/SOAP/WSDL/SOAP/Operation.pm \
	  lib/SOAP/WSDL/SOAP/Typelib/Fault.pm blib/lib/SOAP/WSDL/SOAP/Typelib/Fault.pm \
	  lib/SOAP/WSDL/SOAP/Typelib/Fault11.pm blib/lib/SOAP/WSDL/SOAP/Typelib/Fault11.pm \
	  lib/SOAP/WSDL/Serializer/XSD.pm blib/lib/SOAP/WSDL/Serializer/XSD.pm \
	  lib/SOAP/WSDL/Server.pm blib/lib/SOAP/WSDL/Server.pm \
	  lib/SOAP/WSDL/Server/CGI.pm blib/lib/SOAP/WSDL/Server/CGI.pm \
	  lib/SOAP/WSDL/Server/Mod_Perl2.pm blib/lib/SOAP/WSDL/Server/Mod_Perl2.pm \
	  lib/SOAP/WSDL/Server/Simple.pm blib/lib/SOAP/WSDL/Server/Simple.pm \
	  lib/SOAP/WSDL/Service.pm blib/lib/SOAP/WSDL/Service.pm \
	  lib/SOAP/WSDL/Transport/HTTP.pm blib/lib/SOAP/WSDL/Transport/HTTP.pm \
	  lib/SOAP/WSDL/Transport/Loopback.pm blib/lib/SOAP/WSDL/Transport/Loopback.pm \
	  lib/SOAP/WSDL/Transport/Test.pm blib/lib/SOAP/WSDL/Transport/Test.pm \
	  lib/SOAP/WSDL/TypeLookup.pm blib/lib/SOAP/WSDL/TypeLookup.pm \
	  lib/SOAP/WSDL/Types.pm blib/lib/SOAP/WSDL/Types.pm \
	  lib/SOAP/WSDL/XSD/Annotation.pm blib/lib/SOAP/WSDL/XSD/Annotation.pm \
	  lib/SOAP/WSDL/XSD/Attribute.pm blib/lib/SOAP/WSDL/XSD/Attribute.pm \
	  lib/SOAP/WSDL/XSD/AttributeGroup.pm blib/lib/SOAP/WSDL/XSD/AttributeGroup.pm \
	  lib/SOAP/WSDL/XSD/Builtin.pm blib/lib/SOAP/WSDL/XSD/Builtin.pm \
	  lib/SOAP/WSDL/XSD/ComplexType.pm blib/lib/SOAP/WSDL/XSD/ComplexType.pm \
	  lib/SOAP/WSDL/XSD/Element.pm blib/lib/SOAP/WSDL/XSD/Element.pm \
	  lib/SOAP/WSDL/XSD/Enumeration.pm blib/lib/SOAP/WSDL/XSD/Enumeration.pm \
	  lib/SOAP/WSDL/XSD/FractionDigits.pm blib/lib/SOAP/WSDL/XSD/FractionDigits.pm \
	  lib/SOAP/WSDL/XSD/Group.pm blib/lib/SOAP/WSDL/XSD/Group.pm \
	  lib/SOAP/WSDL/XSD/Length.pm blib/lib/SOAP/WSDL/XSD/Length.pm \
	  lib/SOAP/WSDL/XSD/MaxExclusive.pm blib/lib/SOAP/WSDL/XSD/MaxExclusive.pm \
	  lib/SOAP/WSDL/XSD/MaxInclusive.pm blib/lib/SOAP/WSDL/XSD/MaxInclusive.pm \
	  lib/SOAP/WSDL/XSD/MaxLength.pm blib/lib/SOAP/WSDL/XSD/MaxLength.pm \
	  lib/SOAP/WSDL/XSD/MinExclusive.pm blib/lib/SOAP/WSDL/XSD/MinExclusive.pm \
	  lib/SOAP/WSDL/XSD/MinInclusive.pm blib/lib/SOAP/WSDL/XSD/MinInclusive.pm \
	  lib/SOAP/WSDL/XSD/MinLength.pm blib/lib/SOAP/WSDL/XSD/MinLength.pm \
	  lib/SOAP/WSDL/XSD/Pattern.pm blib/lib/SOAP/WSDL/XSD/Pattern.pm \
	  lib/SOAP/WSDL/XSD/Schema.pm blib/lib/SOAP/WSDL/XSD/Schema.pm \
	  lib/SOAP/WSDL/XSD/Schema/Builtin.pm blib/lib/SOAP/WSDL/XSD/Schema/Builtin.pm \
	  lib/SOAP/WSDL/XSD/SimpleType.pm blib/lib/SOAP/WSDL/XSD/SimpleType.pm \
	  lib/SOAP/WSDL/XSD/TotalDigits.pm blib/lib/SOAP/WSDL/XSD/TotalDigits.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Attribute.pm blib/lib/SOAP/WSDL/XSD/Typelib/Attribute.pm \
	  lib/SOAP/WSDL/XSD/Typelib/AttributeSet.pm blib/lib/SOAP/WSDL/XSD/Typelib/AttributeSet.pm 
	$(NOECHO) $(ABSPERLRUN) -MExtUtils::Install -e 'pm_to_blib({@ARGV}, '\''$(INST_LIB)/auto'\'', q[$(PM_FILTER)], '\''$(PERM_DIR)'\'')' -- \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/ENTITY.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/ENTITY.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/ID.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/ID.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/IDREF.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/IDREF.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/IDREFS.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/IDREFS.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/NCName.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/NCName.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/NMTOKEN.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/NMTOKEN.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/NMTOKENS.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/NMTOKENS.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/NOTATION.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/NOTATION.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/Name.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/Name.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/QName.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/QName.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/anySimpleType.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/anySimpleType.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/anyType.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/anyType.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/anyURI.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/anyURI.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/base64Binary.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/base64Binary.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/boolean.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/boolean.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/byte.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/byte.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/date.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/date.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/dateTime.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/dateTime.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/decimal.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/decimal.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/double.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/double.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/duration.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/duration.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/float.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/float.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/gDay.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/gDay.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/gMonth.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/gMonth.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/gMonthDay.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/gMonthDay.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/gYear.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/gYear.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/gYearMonth.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/gYearMonth.pm 
	$(NOECHO) $(ABSPERLRUN) -MExtUtils::Install -e 'pm_to_blib({@ARGV}, '\''$(INST_LIB)/auto'\'', q[$(PM_FILTER)], '\''$(PERM_DIR)'\'')' -- \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/hexBinary.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/hexBinary.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/int.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/int.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/integer.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/integer.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/language.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/language.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/list.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/list.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/long.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/long.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/negativeInteger.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/negativeInteger.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/nonNegativeInteger.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/nonNegativeInteger.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/nonPositiveInteger.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/nonPositiveInteger.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/normalizedString.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/normalizedString.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/positiveInteger.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/positiveInteger.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/short.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/short.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/string.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/string.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/time.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/time.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/token.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/token.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/unsignedByte.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/unsignedByte.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/unsignedInt.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/unsignedInt.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/unsignedLong.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/unsignedLong.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Builtin/unsignedShort.pm blib/lib/SOAP/WSDL/XSD/Typelib/Builtin/unsignedShort.pm \
	  lib/SOAP/WSDL/XSD/Typelib/ComplexType.pm blib/lib/SOAP/WSDL/XSD/Typelib/ComplexType.pm \
	  lib/SOAP/WSDL/XSD/Typelib/Element.pm blib/lib/SOAP/WSDL/XSD/Typelib/Element.pm \
	  lib/SOAP/WSDL/XSD/Typelib/SimpleType.pm blib/lib/SOAP/WSDL/XSD/Typelib/SimpleType.pm \
	  lib/SOAP/WSDL/XSD/WhiteSpace.pm blib/lib/SOAP/WSDL/XSD/WhiteSpace.pm \
	  test_html.pl $(INST_LIB)/SOAP/test_html.pl \
	  tmp.pl $(INST_LIB)/SOAP/tmp.pl 
	$(NOECHO) $(TOUCH) pm_to_blib


# --- MakeMaker selfdocument section:


# --- MakeMaker postamble section:


# End.
