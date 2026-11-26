#!/usr/bin/env python

import math
import re

sign = r'[+\-]'
digits = r'\d+'
integerNumber = fr' {sign}? {digits} '
numerator = fr' (?P<numerator> {integerNumber} ) '
denominator = fr' (?P<denominator> {integerNumber} ) '
TOP = re.compile(fr"""
^ {numerator} \/ {denominator} (?P<remaining> .* ) $
""",
  re.VERBOSE
)

def parse_fractions(expr):
  fractions = []
  while parsed := TOP.search(expr):
    fractions.append([
      int(parsed.group('numerator')),
      int(parsed.group('denominator'))
    ])
    expr = parsed.group('remaining')
  return fractions

def add_fractions(A, B):
  if A[1] != B[1]:
    # the denominators don't match, so let's make them match
    (A[0],        A[1],        B[0],        B[1]) = (
     A[0] * B[1], A[1] * B[1], B[0] * A[1], B[1] * A[1]
    )
  s = A[0] + B[0]
  return [s, A[1]]

def simplify_fraction(A, B):
  if A == 0: return "0/1"
  d = math.gcd(A, B)
  return f'{A // d}/{B // d}'

def fractional_addition_substraction(expr):
  fractions = parse_fractions(expr)
  while (len(fractions) >= 2):
    fractions.append(
      add_fractions(fractions.pop(0), fractions.pop(0))
    )
  return simplify_fraction(fractions[0][0], fractions[0][1])

def solution(expr):
  print(f'Input: $expr = "{expr}"')
  result = fractional_addition_substraction(expr)
  print(f'Output: "{result}"')

print('Example 1')
solution("1/2+3/2")

print('\nExample 2')
solution("-5/2-3/2")

print('\nExample 3')
solution("5/3-5/3")

print('\nExample 4')
solution("10/10-1/10+2/5")

print('\nExample 5')
solution("1/6+1/6+1/6")
