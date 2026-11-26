#!/usr/bin/env python

from collections import Counter

num_bag = [
  Counter([ c for c in "zero" ]),
  Counter([ c for c in "one" ]),
  Counter([ c for c in "two" ]),
  Counter([ c for c in "three" ]),
  Counter([ c for c in "four" ]),
  Counter([ c for c in "five" ]),
  Counter([ c for c in "six" ]),
  Counter([ c for c in "seven" ]),
  Counter([ c for c in "eight" ]),
  Counter([ c for c in "nine" ])
]

def reconstruct_digits(string):
  charbag = Counter([ c for c in string ])
  output = []
  for digit in [0,2,4,6,8,7,5,3,1,9]:
    while num_bag[digit] <= charbag:
      output.append(digit)
      charbag -= num_bag[digit]
  out = "".join(map(str, sorted(output)))
  if len(charbag) > 0:
    raise ValueError(
      f'{out}, but extra characters were found: ' +
      " ".join(charbag.elements())
    )
  return out

def solution(string):
  print(f'Input: $str = "{string}"')
  output = reconstruct_digits(string)
  print(f'Output: "{output}"')

print('Example 1')
solution("zroezerotwotwotwo")

print('\nExample 2')
solution("sveeeinght")

print('\nExample 3')
solution("onenineninefive")

print('\nExample 4')
solution("zeroonetwothreeeightfivesixsevenninefour")

print('\nExample 5')
solution("ninenineninenine")

print('\nExample 6')
solution("onestewv")
