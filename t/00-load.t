#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 2;

BEGIN {
    for (qw( Navit::WebsiteCreator Navit::WebsiteCreator::Converter )) {
        use_ok($_) || print "Bail out!\n";
    }
}

diag(
    "Testing Navit::WebsiteCreator $Navit::WebsiteCreator::VERSION, Perl $], $^X"
);
