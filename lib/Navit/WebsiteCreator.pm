package Navit::WebsiteCreator;

#===============================================================================
#
#         FILE:  lib/Navit/WebsiteCreator.pm
#
#  DESCRIPTION:  HTML dumper of upcoming www.navit-project.org
#
#        FILES:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Marc0, <Marc0@hidden-primary.net>
#      VERSION:  0.0.1
#      CREATED:  20.03.2016
#===============================================================================

use MooseX::App::Simple;
use Carp;
use Try::Tiny;
use StaticVolt;
use Navit::WebsiteCreator::Converter;

=head1 NAME

Navit::WebsiteCreator - HTML dumper of upcoming www.navit-project.org

=head1 VERSION

Version 0.0.1

=cut

our $VERSION = '0.0.1';

=head1 SYNOPSIS

Iterates templates in L<templates directory/templates> recursively dropping
static HTML output to L<destination>.

    use Navit::WebsiteCreator;

    Navit::WebsiteCreator->new(
        # mandatory
        destination   => q(...some writable directory...)

        # optional
        basedir  => q(...some directory to cd to...),
        rcsdirs  => [qw(...directory patterns...)],
        includes => q(...),
        layouts  => q(...),
        source   => q(...),
    )->process;

=head1 DESCRIPTION

This is a Moose'ish static website generator approach based on
L<StaticVolt|https://metacpan.org/pod/StaticVolt>.
The sources comprising the website are stored within this package, the export
destination is the L<git repo of the Navit
website|https://github.com/navit-gps/website>.

=cut

=head2 Properties

=head3 basedir

Project base dir.
The scripts tries to change to that directory.
Default is the current directory C<.>.

=cut

option q(basedir) => (
    is            => q(ro),
    isa           => q(Str),
    lazy          => 1,
    builder       => q(_build_basedir),
    documentation => q(Local directory containing the website sources.),
);

=head3 rcsdirs

Directory patterns, default C<.git>.
These patterns are used to check files within L<destination>. If a file (its
path) matches one of these patterns, it is not unlinked while destination
preparation.

=cut

has q(rcsdirs) => (
    is      => q(ro),
    isa     => q(ArrayRef[Str]),
    lazy    => 1,
    builder => q(_build_rcsdirs),
);

=head3 includes

Specifies the directory in which to search for template files. By default, it
is set to C<_includes>.

=cut

option q(includes) => (
    is      => q(ro),
    isa     => q(Str),
    lazy    => 1,
    builder => q(_build_includes),
    documentation =>
        q(Specifies the directory in which to search for template files. By default, it is set to "_includes".),
);

=head3 layouts

Specifies the directory in which to search for layouts or wrappers. By default,
it is set to C<_layouts>.

=cut

option q(layouts) => (
    is      => q(ro),
    isa     => q(Str),
    lazy    => 1,
    builder => q(_build_layouts),
    documentation =>
        q(Specifies the directory in which to search for layouts or wrappers. By default, it is set to "_layouts"),
);

=head3 source

Specifies the directory in which source files reside. Source files are files
which will be compiled to HTML if they have a registered convertor and a YAML
configuration in the beginning. By default, it is set to C<_source>.

=cut

option q(source) => (
    is      => q(ro),
    isa     => q(Str),
    lazy    => 1,
    builder => q(_build_source),
    documentation =>
        q(Specifies the directory in which source files reside. Source files are files which will be compiled to HTML if they have a registered convertor and a YAML configuration in the beginning. By default, it is set to "_source".),
);

=head3 destination

Directory to write output files to.

=cut

option q(destination) => (
    is       => q(rw),
    isa      => q(Str),
    required => 1,
    documentation =>
        q(This directory will be created if it does not exist. Compiled and output files are placed in this directory.),
);

=head3 _staticvolt

Delegation to L<StaticVolt>.

=cut

has q(_staticvolt) => (
    is      => q(ro),
    isa     => q(StaticVolt),
    handles => [qw( compile _rcs_paths _is_rcs_dir )],
    lazy    => 1,
    builder => q(_build__staticvolt),
);

=head2 Methods

=cut

=head3 run

Kicks L<StaticVolt's compile|StaticVolt/compile> method.

=cut

sub run {
    my ($self) = @_;

    my $base = $self->basedir;
    chdir $base
        or croak(qq(Unable to change to directory $base: $!));

    # "compile" is delegated via "_staticvolt"
    $self->compile();
} ## end sub run

=head3 _build_basedir

Builder of L<basedir>.
Returns C<.> if invoked.

=cut

sub _build_basedir {q(.)}

=head3 _build_rcsdirs

Builder of L<rcsdirs> property, just returns C<[qw( .git )]>.

=cut

sub _build_rcsdirs { [qw( .git )] }

=head3 _build_includes

Builder of L<templates> property, just returns C<_includes>.

=cut

sub _build_includes {q(_includes)}

=head3 _build_layouts

Builder of L<layout> property, just returns C<_includes>.

=cut

sub _build_layouts {q(_includes)}

=head3 _build_source

Builder of L<source> property just returning C<_source>.

=cut

sub _build_source {q(_source)}

=head3 _build__staticvolt

Builder of L<_staticvolt>.

=cut

sub _build__staticvolt {
    my ($self) = @_;
    my $sv = StaticVolt->new(map { $_ => $self->$_ }
            qw( destination includes layouts source ));
    $sv->_rcs_paths(@{ $self->rcsdirs });
    return $sv;
} ## end sub _build__staticvolt

package StaticVolt;

use strict;
use warnings;
use Carp;
use File::Find qw();
use File::Spec qw();

{
    no warnings qw( redefine );

    # monkey patching
    sub _clean_destination {
        my ($self) = @_;

        my $destination = $self->{destination};
        croak(q(Destination directory is missing))
            unless $destination;
        croak(qq(Destination "$destination" is not a directory))
            unless -d $destination;

        File::Find::find(
            sub {
                my $file = $_;
                return
                    unless -f $file;
                unless ($self->_is_rcs_dir($File::Find::dir)) {
                    try {
                        unlink $file
                            or croak(qq(Unable to unlink $file: $!));
                        return;
                    }
                    catch {
                        carp(qq(Error while clean-up: $_));
                        return;
                    };
                } ## end unless ($self->_is_rcs_dir...)
            },
            $destination
        );
    } ## end sub _clean_destination

    # Directories used for different RCSs.
    # These directories must not be removed by our "_clean_destination".
    my @rcs_paths = qw( .git .svn );

    sub _rcs_paths {
        my ($self, @dirs) = @_;

        $self->{rcs_paths} = [@rcs_paths]
            unless exists $self->{rcs_paths};
        $self->{rcs_paths} = [@dirs]
            if @dirs;

        # cast to array again
        @{ $self->{rcs_paths} };
    } ## end sub _rcs_paths

    sub _is_rcs_dir {
        my ($self, $dir) = @_;

        return
            unless defined $dir;

        my @dirs       = File::Spec->splitdir($dir);
        my @_rcs_paths = $self->_rcs_paths;
        0 < grep {
            my $_dir = $_;
            grep { qq($_dir) eq qq($_) } @_rcs_paths
        } @dirs;
    } ## end sub _is_rcs_dir
}

=head1 NOTES

This package L<monkey patches|https://en.wikipedia.org/wiki/Monkey_patch> the
L<_clean_destination|StaticVolt/_clean_destination> method to keep RCS files in
place.

=head1 INSTALL

=head1 BUGS

=head1 AUTHOR

Marc0, C<< <Marc0 at hidden-primary.net> >>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Navit::WebsiteCreator


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
