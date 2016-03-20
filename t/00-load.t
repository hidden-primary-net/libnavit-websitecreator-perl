#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Navit::WebsiteCreator' ) || print "Bail out!\n";
}

diag( "Testing Navit::WebsiteCreator $Navit::WebsiteCreator::VERSION, Perl $], $^X" );
