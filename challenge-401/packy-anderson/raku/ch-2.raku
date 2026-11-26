#!/usr/bin/env raku
use v6;

my @num_bag = [
  "zero".comb.Bag,
  "one".comb.Bag,
  "two".comb.Bag,
  "three".comb.Bag,
  "four".comb.Bag,
  "five".comb.Bag,
  "six".comb.Bag,
  "seven".comb.Bag,
  "eight".comb.Bag,
  "nine".comb.Bag
];

sub reconstructDigits($str) {
  my $charbag = $str.comb.BagHash;
  my @output;
  for [0,2,4,6,8,7,5,3,1,9] -> $digit {
    while ( @num_bag[$digit] ⊆ $charbag ) {
      @output.append($digit);
      $charbag.remove(@num_bag[$digit].kxxv);
    }
  }
  die "{@output.sort.join}, but extra characters were found: "
    ~ "{$charbag.kxxv}\n" if $charbag.kxxv;
  @output.sort.join;
}

sub solution($str) {
  say 'Input: $str = "' ~ $str ~ '"';
  my $output = reconstructDigits($str);
  say 'Output: "' ~ $output ~ '"';
}

say "Example 1";
solution("zroezerotwotwotwo");

say "\nExample 2";
solution("sveeeinght");

say "\nExample 3";
solution("onenineninefive");

say "\nExample 4";
solution("zeroonetwothreeeightfivesixsevenninefour");

say "\nExample 5";
solution("ninenineninenine");

say "\nExample 6";
solution("onestewv");