#!/usr/bin/env raku
use v6;

grammar Fraction {
  token TOP { <numerator> \/ <denominator> <remaining> }
  token sign { <[ + \- ]> }
  token digits { \d+ }
  token integerNumber { <sign>? <digits> }
  token numerator { <integerNumber> }
  token denominator { <integerNumber> }
  token remaining { .* }
}

sub parseFractions($expr is copy) {
  my @fractions;
  while (my $parsed = Fraction.parse($expr)) {
    @fractions.push([
      $parsed<numerator>.Int, $parsed<denominator>.Int
    ]);
    $expr = $parsed<remaining>.Str;
  }
  @fractions;
}

sub addFractions($A, $B) {
  if ($A[1] != $B[1]) {
    # the denominators don't match, so let's make them match
    ($A[0], $A[1],
     $B[0], $B[1]) =
    ($A[0] * $B[1], $A[1] * $B[1],
     $B[0] * $A[1], $B[1] * $A[1])
  }
  my $sum = $A[0] + $B[0];
  [$sum, $A[1]];
}

sub simplifyFraction($A, $B) {
   my $d = $A gcd $B;
   join "/", $A / $d, $B / $d;
}

sub fractionalAdditionSubstraction($expr is copy) {
  my @fractions = parseFractions($expr);

  while (@fractions.elems >= 2) {
    @fractions.push(
      addFractions(@fractions.shift, @fractions.shift)
    );
  }
  simplifyFraction(@fractions[0][0], @fractions[0][1]);
}

sub solution($expr) {
  say 'Input: $expr = "' ~ $expr ~ '"';
  my $result = fractionalAdditionSubstraction($expr);
  say 'Output: "' ~ $result ~ '"';
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
