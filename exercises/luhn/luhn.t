#!/usr/bin/env perl6
use v6;
use Test;
use lib my $dir = $?FILE.IO.dirname;
use JSON::Tiny;

my $exercise = 'Luhn';
my $version = v1;
my $module = %*ENV<EXERCISM> ?? 'Example' !! $exercise;
plan 15;

use-ok $module or bail-out;
require ::($module);

if ::($exercise).^ver !~~ $version {
  warn "\nExercise version mismatch. Further tests may fail!"
    ~ "\n$exercise is $(::($exercise).^ver.gist). "
    ~ "Test is $($version.gist).\n";
  bail-out 'Example version must match test version.' if %*ENV<EXERCISM>;
}

require ::($module) <&is-luhn-valid>;

my $c-data;
is .<input>.&is-luhn-valid, |.<expected description> for @($c-data<cases>);

if %*ENV<EXERCISM> && (my $c-data-file =
  "$dir/../../problem-specifications/exercises/{$dir.IO.resolve.basename}/canonical-data.json".IO.resolve) ~~ :f
{ is-deeply $c-data, from-json($c-data-file.slurp), 'canonical-data' } else { skip }

done-testing;

INIT {
$c-data := from-json q:to/END/;

{
  "exercise": "luhn",
  "version": "1.0.0",
  "cases": [
    {
      "description": "single digit strings can not be valid",
      "property": "valid",
      "input": "1",
      "expected": false
    },
    {
      "description": "A single zero is invalid",
      "property": "valid",
      "input": "0",
      "expected": false
    },
    {
      "description": "a simple valid SIN that remains valid if reversed",
      "property": "valid",
      "input": "059",
      "expected": true
    },
    {
      "description": "a simple valid SIN that becomes invalid if reversed",
      "property": "valid",
      "input": "59",
      "expected": true
    },
    {
      "description": "a valid Canadian SIN",
      "property": "valid",
      "input": "055 444 285",
      "expected": true
    },
    {
      "description": "invalid Canadian SIN",
      "property": "valid",
      "input": "055 444 286",
      "expected": false
    },
    {
      "description": "invalid credit card",
      "property": "valid",
      "input": "8273 1232 7352 0569",
      "expected": false
    },
    {
      "description": "valid strings with a non-digit included become invalid",
      "property": "valid",
      "input": "055a 444 285",
      "expected": false
    },
    {
      "description": "valid strings with punctuation included become invalid",
      "property": "valid",
      "input": "055-444-285",
      "expected": false
    },
    {
      "description": "valid strings with symbols included become invalid",
      "property": "valid",
      "input": "055£ 444$ 285",
      "expected": false
    },
    {
      "description": "single zero with space is invalid",
      "property": "valid",
      "input": " 0",
      "expected": false
    },
    {
      "description": "more than a single zero is valid",
      "property": "valid",
      "input": "0000 0",
      "expected": true
    },
    {
      "description": "input digit 9 is correctly converted to output digit 9",
      "property": "valid",
      "input": "091",
      "expected": true
    }
  ]
}

END
}
