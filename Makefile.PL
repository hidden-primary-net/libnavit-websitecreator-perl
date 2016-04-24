use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME               => 'Navit::WebsiteCreator',
    AUTHOR             => q{Marc0 <Marc0@hidden-primary.net>},
    VERSION_FROM       => 'lib/Navit/WebsiteCreator.pm',
    ABSTRACT_FROM      => 'lib/Navit/WebsiteCreator.pm',
    LICENSE            => 'GPL_3',
    PL_FILES           => {},
    MIN_PERL_VERSION   => 5.006,
    CONFIGURE_REQUIRES => { 'ExtUtils::MakeMaker' => 0, },
    BUILD_REQUIRES     => {
        q(Test::More)                           => 0,
        q(MooseX::App::Simple)                  => 0,
        q(namespace::autoclean)                 => 0,
        q(Template)                             => 0,
        q(Template::Plugin::Filter::MinifyHTML) => 0,
        q(Try::Tiny)                            => 0,
        q(StaticVolt)                           => 0,
        q(FindBin)                              => 0,
        q(File::Spec)                           => 0,
        q(File::Find)                           => 0,
    },
    ## FIXME
    ## fatpacked these are not neccessary?
    PREREQ_PM => {
        q(MooseX::App::Simple)                  => 0,
        q(namespace::autoclean)                 => 0,
        q(Template)                             => 0,
        q(Template::Plugin::Filter::MinifyHTML) => 0,
        q(Try::Tiny)                            => 0,
        q(StaticVolt)                           => 0,
        q(File::Spec)                           => 0,
        q(File::Find)                           => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'Navit-WebsiteCreator-*' },
);
