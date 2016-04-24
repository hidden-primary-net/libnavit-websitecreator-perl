package Navit::WebsiteCreator::Converter;

#===============================================================================
#
#         FILE:  lib/Navit/WebsiteCreator/Converter.pm
#
#  DESCRIPTION:  Template converter
#
#        FILES:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Marc0, <Marc0@hidden-primary.net>
#      VERSION:  0.0.1
#      CREATED:  20.03.2016
#===============================================================================

use strict;
use warnings;
use base qw( StaticVolt::Convertor );
use Carp;

=head1 NAME

Navit::WebsiteCreator::Converter - Template converter

=head1 SYNOPSIS

=head1 DESCRIPTION

=head2 Methods

=head3 convert

=cut

sub convert {
    use Data::Dumper;
    warn Data::Dumper->Dump([ \@_ ]);
    $_[0];
}

__PACKAGE__->register(qw( tt2 tt2html html ));

=head1 AUTHOR

Marc0, C<< <Marc0 at hidden-primary.net> >>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Navit::WebsiteCreator::Converter


=head1 LICENSE AND COPYRIGHT

Copyright 2016 Marc0.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see L<http://www.gnu.org/licenses/>.

=cut

1;
