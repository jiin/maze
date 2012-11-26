#!/usr/bin/perl

use strict;

# I don't use warnings because Perl interpreter warn about recursion.

use feature 'say';

use Term::ANSIColor;
use List::Util qw(shuffle min);

my @DIRECTIONS = (
  [ 1, 0 ], [ -1, 0 ],
  [ 0, 1 ], [ 0, -1 ]
);

my $width = $ARGV[0] or usage();
my $height = $ARGV[1] or usage();

my %x = (
  start => int( rand( $width )),
  end   => int( rand( $width ))
);

my %y = (
  start => 0,
  end   => $height - 1
);

my @horizontal_walls = map { [ map { 1 } 1..$width ] } 1..$height;
my @vertical_walls   = map { [ map { 1 } 1..$width ] } 1..$height;
my @path_for_solving = map { [ map { 0 } 1..$width ] } 1..$height;
my @cells_visited    = ();

$horizontal_walls[ $y{'end'} ]->[ $x{'end'} ] = 0;

generate();

sub generate {
  reset_visiting_state();
  generate_visit_cell( $x{'start'}, $y{'start'} );
  reset_visiting_state();
  print_matrix();
}

sub generate_visit_cell {
  my( $x, $y ) = @_;

  $cells_visited[$y]->[$x] = 1;

  my @coordinates = ();
  foreach( shuffle @DIRECTIONS ) {
    push( @coordinates, [ $x + $_->[0], $y + $_->[1] ] );
  }

  for( my $i = 0; $i <= $#coordinates; $i++ ) {
    next unless move_valid( $coordinates[$i]->[0], $coordinates[$i]->[1] );

    connect_cells( $x, $y, $coordinates[$i]->[0], $coordinates[$i]->[1] );
    generate_visit_cell( $coordinates[$i]->[0], $coordinates[$i]->[1] );
  }
}

sub reset_visiting_state {
  @cells_visited = map { [ map { 0 } 1..$width ] } 1..$height;
}

sub connect_cells {
  my( $x, $y, $x1, $y1 ) = @_;

  ( $x == $x1 ) 
  ? $horizontal_walls[ min( $y, $y1 ) ]->[ $x ] = 0 
  : $vertical_walls[ $y ]->[ min( $x, $x1 ) ] = 0;
}

sub move_valid {
  my( $x, $y ) = @_;

  return( coordinate_valid( $x, $y ) && !( $cells_visited[$y][$x] ) );
}

sub coordinate_valid {
  my( $x, $y ) = @_;

  return (( $x >= 0 ) && ( $y >= 0 ) && ( $x < $width ) && ( $y < $height ));
}

sub print_matrix {
  my $line = '+';

  for( my $i = 0; $i < $width; $i++ ) {
    $line .= ( $i == $x{'start'} ) ? '   +' : '---+';
  }

  say colored( $line, 'green' );

  my( $y, $x );
  for( $y = 0; $y < $height; $y++ ) {

    $line = '|';

    for( $x = 0; $x < $width; $x++ ) {
      $line .= ( $path_for_solving[$y][$x] ? ' o ' : '   ' );
      $line .= ( $vertical_walls[$y]->[$x] ? '|' : ' ' );
    }

    say colored( $line, 'red' );

    $line = '+';

    for( $x = 0; $x < $width; $x++ ) {
      $line .= ( $horizontal_walls[$y]->[$x] ? '---+' : '   +' );
    }

    say colored( $line, 'green' );
  }
}

sub usage {
  say '--- Maze';
  say 'Usage: perl ./maze.pl <width> <height>';
  exit(0);
}

=pod 

=head1 NAME

maze.pl - relaxing labyrinth generator

=head1 SYNOPSIS

perl maze.pl <width> <height>

=head1 DESCRIPTION

maze.pl allows you to generate labyrinth for say 'NO' to the daily boredom.

=head1 DEPENDENCIES

Term::ANSIColor ~ http://search.cpan.org/~rra/Term-ANSIColor-3.02/ANSIColor.pm

=head1 LICENSE AND COPYRIGHT

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or (at
your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

On Debian systems, the complete text of the GNU General Public License
can be found in /usr/share/common-licenses/GPL-3.

=head1 AUTHOR

jiin < nyutsuki [at] gmail [dot] com >

=cut