#!/usr/bin/perl

#===============================================================================
#
#         FILE:  t/20-navit-websitecreator.t
#
#  DESCRIPTION:  Object regression tests
#
#        FILES:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Marc0, <Marc0@hidden-primary.net>
#      VERSION:  0.0.1
#      CREATED:  24.04.2016
#===============================================================================

use strict;
use warnings;
use Carp;
use 5.12.0;
use FindBin;
use Try::Tiny;
use Test::More;

subtest q(Checking object) => sub {
    use_ok(q(Navit::WebsiteCreator));
    my $nc = Navit::WebsiteCreator->new(destination => test_destination());
    isa_ok($nc, q(Navit::WebsiteCreator));
    for (qw( compile _rcs_paths _is_rcs_dir )) {
        can_ok($nc, $_);
    }
};

subtest q(Checking RCS file detection) => sub {
    my $nc = Navit::WebsiteCreator->new(destination => test_destination());
    my @rcs_dirs = $nc->_rcs_paths;
    for (
        qw( /tmp/.git /tmp/.git/a /tmp/.git/.gitconfig /tmp/.git/objects/00 ))
    {
        ok($nc->_is_rcs_dir($_), qq(Found RCS-related filename "$_"));
    }
    for (
        qw( /tmp/a.git /tmp/b.git/a /tmp/c.svn /tmp/d.svn/b /tmp/.svn /tmp/.svn/b /tmp/.svn/entries )
        )
    {
        ok(!$nc->_is_rcs_dir($_), qq(Found non-RCS-related filename "$_"));
    } ## end for (...)

    note q(Changing RCS dir definition);
    $nc->_rcs_paths(qw( .git .svn ));
    for (
        qw( /tmp/.git /tmp/.git/a /tmp/.svn /tmp/.svn/b /tmp/.git/.gitconfig /tmp/.git/objects/00 /tmp/.svn/entries )
        )
    {
        ok($nc->_is_rcs_dir($_), qq(Found RCS-related filename "$_"));
    } ## end for (...)
    for (qw( /tmp/a.git /tmp/b.git/a /tmp/c.svn /tmp/d.svn/b )) {
        ok(!$nc->_is_rcs_dir($_), qq(Found non-RCS-related filename "$_"));
    }
};

done_testing();

sub test_destination {
    require File::Spec;
    File::Spec->catdir($FindBin::Bin, q(out));
}

BEGIN {
    my $d = test_destination();
    return
        if -d $d;
    mkdir $d
        or croak(qq(Unable to create destination: $!));
} ## end BEGIN

END {
    try {
        my $dir2clean = test_destination();
        croak(q(No directory to clean))
            unless $dir2clean;
        return
            unless -e $dir2clean;
        require File::Path;
        File::Path::remove_tree($dir2clean);
    } ## end try
    catch {
        warn qq(Unable to clean up: $_);
        return;
    };
} ## end END

__END__

