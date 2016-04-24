#!/usr/bin/perl
#===============================================================================
#
#         FILE:  bin/navit-website-make.pl
#
#        USAGE:  bin/navit-website-make.pl
#
#  DESCRIPTION:  Create output files from templates
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Marc0, <Marc0@hidden-primary.net>
#      VERSION:  0.0.1
#      CREATED:  20.03.2016
#===============================================================================

use strict;
use warnings;
use Navit::WebsiteCreator;

Navit::WebsiteCreator->new_with_options->run;

__END__

