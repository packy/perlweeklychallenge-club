#!/usr/bin/env perl
use v5.44;

use Math::Utils qw( gcd );

my $sign = qr/ [ + \- ] /x;
my $digits = qr/ \d+ /x;
my $integerNumber = qr/ $sign? $digits /x;
my $numerator = qr/ (?<numerator> $integerNumber ) /x;
my $denominator = qr/ (?<denominator> $integerNumber ) /x;
my $TOP  = qr/^ $numerator \/ $denominator (?<remaining> .* ) $/x;

sub parseFractions($expr) {
  my @fractions;
  while ($expr =~ /$TOP/) {
    push @fractions, [ $+{numerator}, $+{denominator} ];
    $expr = $+{remaining};
  }
  @fractions;
}

sub addFractions($A, $B) {
  if ($A->[1] != $B->[1]) {
    # the denominators don't match, so let's make them match
    ($A->[0], $A->[1],
     $B->[0], $B->[1]) =
    ($A->[0] * $B->[1], $A->[1] * $B->[1],
     $B->[0] * $A->[1], $B->[1] * $A->[1])
  }
  my $sum = $A->[0] + $B->[0];
  [$sum, $A->[1]];
}

sub simplifyFraction($A, $B) {
  return "0/1" if $A == 0;
  my $d = gcd([$A, $B]);
  join "/", $A / $d, $B / $d;
}

sub fractionalAdditionSubstraction($expr) {
  my @fractions = parseFractions($expr);
  while (@fractions >= 2) {
    push @fractions,
      addFractions(shift @fractions, shift @fractions);
  }
  simplifyFraction($fractions[0]->[0], $fractions[0]->[1]);
}

sub solution($expr) {
  say 'Input: $expr = "' . $expr . '"';
  my $result = fractionalAdditionSubstraction($expr);
  say 'Output: "' . $result . '"';
}

say "Example 1";
solution("1/2+3/2");

say "\nExample 2";
solution("-5/2-3/2");

say "\nExample 3";
solution("5/3-5/3");

say "\nExample 4";
solution("10/10-1/10+2/5");

say "\nExample 5";
solution("1/6+1/6+1/6");
