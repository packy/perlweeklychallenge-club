#!/usr/bin/env perl
use v5.44;

package MyBag;

use List::MoreUtils qw( frequency );
use Set::Bag;

use base qw/ Set::Bag /;

sub new($class, $str) {
  my $self = Set::Bag->new(frequency split //, $str);
  bless $self, $class;
}

sub subset($self, $other) {
  foreach my ($key, $val) (%$other) {
    # this key is not part of the bag, it's a switch; and the
    # variable defining it is scoped local to the package, so
    # I can't reference it in a child class. :(
    next if $key eq 'Set::Bag::__over_delete__';
    return 0 unless $self->{$key}
                 && $self->{$key} >= $val;
  }
  return 1;
}

sub kxxv($self) {
  map { ($_) x $self->grab($_) } $self->elements;
}

package main;

my @num_bag = (
  MyBag->new("zero"),
  MyBag->new("one"),
  MyBag->new("two"),
  MyBag->new("three"),
  MyBag->new("four"),
  MyBag->new("five"),
  MyBag->new("six"),
  MyBag->new("seven"),
  MyBag->new("eight"),
  MyBag->new("nine")
);

sub reconstructDigits($str) {
  my $charbag = MyBag->new($str);
  my @output;
  for my $digit (0,2,4,6,8,7,5,3,1,9) {

    while ( $charbag->subset($num_bag[$digit]) ) {
      push @output, $digit;
      $charbag->delete($num_bag[$digit]->grab);
    }
  }
  my $out = join "", sort @output;
  if ($charbag->kxxv) {
    die "$out, but extra characters were found: "
      . join(" ", $charbag->kxxv) . "\n";
  }
  $out;
}

sub solution($str) {
  say 'Input: $str = "' . $str . '"';
  my $output = reconstructDigits($str);
  say 'Output: "' . $output . '"';
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
