#!/usr/bin/perl

#===============================================================================
#
#         FILE:  t/10-re.t
#
#  DESCRIPTION:
#
#        FILES:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Marc0, <Marc0@hidden-primary.net>
#      VERSION:  0.0.1
#      CREATED:  14.04.2016
#===============================================================================

use strict;
use warnings;
use Carp;
use 5.12.0;
use Test::More;

subtest q(Checking regular expressions used for delegation) => sub {
    my ($key_re, $key_accept, $key_decline) = qw( re accept decline );
    my @tests = (
        ## everything but /^_clean_destination$/
        {
            $key_re     => qr/^(?!_clean_destination$)/,
            $key_accept => [
                qw( new _traverse_files _clean_destinatio _clean_destinations )
            ],
            $key_decline => [qw( _clean_destination )],
        },
        ## everything but /^_clean_destination/ <= too strong
        {
            $key_re      => qr/^(?!_clean_destination)/,
            $key_accept  => [qw( new _traverse_files _clean_destinatio )],
            $key_decline => [qw( _clean_destination _clean_destinations )],
        },
    );
    while (my (@a) = each @tests) {
        my $v  = $a[1];
        my $re = $v->{$key_re};

        note q(Checking if delegation would be installed);
        like($_, $re, qq(Method "$_" would be delegated))
            for @{ $v->{$key_accept} };

        note q(Checking if delegation would be skipped);
        unlike($_, $re, qq(Method "$_" would NOT be delegated))
            for @{ $v->{$key_decline} };
    } ## end while (my (@a) = each @tests)
};

done_testing();

__END__

