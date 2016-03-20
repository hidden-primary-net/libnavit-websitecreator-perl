use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Navit::WebsiteCreator',
    AUTHOR           => q{Marc0 <Marc0@hidden-primary.net>},
    VERSION_FROM     => 'lib/Navit/WebsiteCreator.pm',
    ABSTRACT_FROM    => 'lib/Navit/WebsiteCreator.pm',
    LICENSE          => 'GPL_3',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        #'ABC'              => 1.6,
        #'Foo::Bar::Module' => 5.0401,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Navit-WebsiteCreator-*' },
);
