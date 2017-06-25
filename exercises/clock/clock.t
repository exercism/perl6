#!/usr/bin/env perl6
use v6;
use Test;
use lib my $dir = $?FILE.IO.dirname;
use JSON::Tiny;

my $exercise = 'Clock';
my $version = v1;
my $module = %*ENV<EXERCISM> ?? 'Example' !! $exercise;
plan 54;

use-ok $module or bail-out;
require ::($module);

if ::($exercise).^ver !~~ $version {
  warn "\nExercise version mismatch. Further tests may fail!"
    ~ "\n$exercise is $(::($exercise).^ver.gist). "
    ~ "Test is $($version.gist).\n";
  bail-out 'Example version must match test version.' if %*ENV<EXERCISM>;
}

subtest 'Class methods', {
  ok ::($exercise).can($_), $_ for <time add-minutes>;
}

my $c-data;
for @($c-data<cases>) {
  for @(.<cases>) -> $case {
    given $case<property> {
      when 'create' {
        is ::($exercise).new(hour => $case<hour>, minute => $case<minute>).?time, |$case<expected description>;
      }
      when 'add' {
        my $clock = ::($exercise).new(hour => $case<hour>, minute => $case<minute>);
        $clock.?add-minutes($case<add>);
        is $clock.?time, |$case<expected description>;
      }
      when 'equal' {
        is ::($exercise).new(hour => $case<clock1><hour>, minute => $case<clock1><minute>).?time eq
           ::($exercise).new(hour => $case<clock2><hour>, minute => $case<clock2><minute>).?time,
           |$case<expected description>;
      }
      when %*ENV<EXERCISM>.so { bail-out "no case for property '$case<property>'" }
    }
  }
}

todo 'optional test' unless %*ENV<EXERCISM>;
is ::($exercise).new(:0hour,:0minute).?add-minutes(65).?time, '01:05', 'add-minutes method can be chained';

if %*ENV<EXERCISM> && (my $c-data-file =
  "$dir/../../problem-specifications/exercises/{$dir.IO.resolve.basename}/canonical-data.json".IO.resolve) ~~ :f
{ is-deeply $c-data, from-json($c-data-file.slurp), 'canonical-data' } else { skip }

done-testing;

INIT {
$c-data := from-json q:to/END/;

{
  "exercise": "clock",
  "version": "1.0.1",
  "comments": [
    "Most languages require constructing a clock with initial values,",
    "adding a positive or negative number of minutes, and testing equality",
    "in some language-native way.  Some languages require separate add and",
    "subtract functions.  Negative and out of range values are generally",
    "expected to wrap around rather than represent errors."
  ],
  "cases": [
    {
      "description": "Create a new clock with an initial time",
      "cases": [
        {
          "description": "on the hour",
          "property": "create",
          "hour": 8,
          "minute": 0,
          "expected": "08:00"
        },
        {
          "description": "past the hour",
          "property": "create",
          "hour": 11,
          "minute": 9,
          "expected": "11:09"
        },
        {
          "description": "midnight is zero hours",
          "property": "create",
          "hour": 24,
          "minute": 0,
          "expected": "00:00"
        },
        {
          "description": "hour rolls over",
          "property": "create",
          "hour": 25,
          "minute": 0,
          "expected": "01:00"
        },
        {
          "description": "hour rolls over continuously",
          "property": "create",
          "hour": 100,
          "minute": 0,
          "expected": "04:00"
        },
        {
          "description": "sixty minutes is next hour",
          "property": "create",
          "hour": 1,
          "minute": 60,
          "expected": "02:00"
        },
        {
          "description": "minutes roll over",
          "property": "create",
          "hour": 0,
          "minute": 160,
          "expected": "02:40"
        },
        {
          "description": "minutes roll over continuously",
          "property": "create",
          "hour": 0,
          "minute": 1723,
          "expected": "04:43"
        },
        {
          "description": "hour and minutes roll over",
          "property": "create",
          "hour": 25,
          "minute": 160,
          "expected": "03:40"
        },
        {
          "description": "hour and minutes roll over continuously",
          "property": "create",
          "hour": 201,
          "minute": 3001,
          "expected": "11:01"
        },
        {
          "description": "hour and minutes roll over to exactly midnight",
          "property": "create",
          "hour": 72,
          "minute": 8640,
          "expected": "00:00"
        },
        {
          "description": "negative hour",
          "property": "create",
          "hour": -1,
          "minute": 15,
          "expected": "23:15"
        },
        {
          "description": "negative hour rolls over",
          "property": "create",
          "hour": -25,
          "minute": 0,
          "expected": "23:00"
        },
        {
          "description": "negative hour rolls over continuously",
          "property": "create",
          "hour": -91,
          "minute": 0,
          "expected": "05:00"
        },
        {
          "description": "negative minutes",
          "property": "create",
          "hour": 1,
          "minute": -40,
          "expected": "00:20"
        },
        {
          "description": "negative minutes roll over",
          "property": "create",
          "hour": 1,
          "minute": -160,
          "expected": "22:20"
        },
        {
          "description": "negative minutes roll over continuously",
          "property": "create",
          "hour": 1,
          "minute": -4820,
          "expected": "16:40"
        },
        {
          "description": "negative hour and minutes both roll over",
          "property": "create",
          "hour": -25,
          "minute": -160,
          "expected": "20:20"
        },
        {
          "description": "negative hour and minutes both roll over continuously",
          "property": "create",
          "hour": -121,
          "minute": -5810,
          "expected": "22:10"
        }
      ]
    },
    {
      "description": "Add minutes",
      "cases": [
        {
          "description": "add minutes",
          "property": "add",
          "hour": 10,
          "minute": 0,
          "add": 3,
          "expected": "10:03"
        },
        {
          "description": "add no minutes",
          "property": "add",
          "hour": 6,
          "minute": 41,
          "add": 0,
          "expected": "06:41"
        },
        {
          "description": "add to next hour",
          "property": "add",
          "hour": 0,
          "minute": 45,
          "add": 40,
          "expected": "01:25"
        },
        {
          "description": "add more than one hour",
          "property": "add",
          "hour": 10,
          "minute": 0,
          "add": 61,
          "expected": "11:01"
        },
        {
          "description": "add more than two hours with carry",
          "property": "add",
          "hour": 0,
          "minute": 45,
          "add": 160,
          "expected": "03:25"
        },
        {
          "description": "add across midnight",
          "property": "add",
          "hour": 23,
          "minute": 59,
          "add": 2,
          "expected": "00:01"
        },
        {
          "description": "add more than one day (1500 min = 25 hrs)",
          "property": "add",
          "hour": 5,
          "minute": 32,
          "add": 1500,
          "expected": "06:32"
        },
        {
          "description": "add more than two days",
          "property": "add",
          "hour": 1,
          "minute": 1,
          "add": 3500,
          "expected": "11:21"
        }
      ]
    },
    {
      "description": "Subtract minutes",
      "cases": [
        {
          "description": "subtract minutes",
          "property": "add",
          "hour": 10,
          "minute": 3,
          "add": -3,
          "expected": "10:00"
        },
        {
          "description": "subtract to previous hour",
          "property": "add",
          "hour": 10,
          "minute": 3,
          "add": -30,
          "expected": "09:33"
        },
        {
          "description": "subtract more than an hour",
          "property": "add",
          "hour": 10,
          "minute": 3,
          "add": -70,
          "expected": "08:53"
        },
        {
          "description": "subtract across midnight",
          "property": "add",
          "hour": 0,
          "minute": 3,
          "add": -4,
          "expected": "23:59"
        },
        {
          "description": "subtract more than two hours",
          "property": "add",
          "hour": 0,
          "minute": 0,
          "add": -160,
          "expected": "21:20"
        },
        {
          "description": "subtract more than two hours with borrow",
          "property": "add",
          "hour": 6,
          "minute": 15,
          "add": -160,
          "expected": "03:35"
        },
        {
          "description": "subtract more than one day (1500 min = 25 hrs)",
          "property": "add",
          "hour": 5,
          "minute": 32,
          "add": -1500,
          "expected": "04:32"
        },
        {
          "description": "subtract more than two days",
          "property": "add",
          "hour": 2,
          "minute": 20,
          "add": -3000,
          "expected": "00:20"
        }
      ]
    },
    {
      "description": "Compare two clocks for equality",
      "cases": [
        {
          "description": "clocks with same time",
          "property": "equal",
          "clock1": {
            "hour": 15,
            "minute": 37
          },
          "clock2": {
            "hour": 15,
            "minute": 37
          },
          "expected": true
        },
        {
          "description": "clocks a minute apart",
          "property": "equal",
          "clock1": {
            "hour": 15,
            "minute": 36
          },
          "clock2": {
            "hour": 15,
            "minute": 37
          },
          "expected": false
        },
        {
          "description": "clocks an hour apart",
          "property": "equal",
          "clock1": {
            "hour": 14,
            "minute": 37
          },
          "clock2": {
            "hour": 15,
            "minute": 37
          },
          "expected": false
        },
        {
          "description": "clocks with hour overflow",
          "property": "equal",
          "clock1": {
            "hour": 10,
            "minute": 37
          },
          "clock2": {
            "hour": 34,
            "minute": 37
          },
          "expected": true
        },
        {
          "description": "clocks with hour overflow by several days",
          "property": "equal",
          "clock1": {
            "hour": 3,
            "minute": 11
          },
          "clock2": {
            "hour": 99,
            "minute": 11
          },
          "expected": true
        },
        {
          "description": "clocks with negative hour",
          "property": "equal",
          "clock1": {
            "hour": 22,
            "minute": 40
          },
          "clock2": {
            "hour": -2,
            "minute": 40
          },
          "expected": true
        },
        {
          "description": "clocks with negative hour that wraps",
          "property": "equal",
          "clock1": {
            "hour": 17,
            "minute": 3
          },
          "clock2": {
            "hour": -31,
            "minute": 3
          },
          "expected": true
        },
        {
          "description": "clocks with negative hour that wraps multiple times",
          "property": "equal",
          "clock1": {
            "hour": 13,
            "minute": 49
          },
          "clock2": {
            "hour": -83,
            "minute": 49
          },
          "expected": true
        },
        {
          "description": "clocks with minute overflow",
          "property": "equal",
          "clock1": {
            "hour": 0,
            "minute": 1
          },
          "clock2": {
            "hour": 0,
            "minute": 1441
          },
          "expected": true
        },
        {
          "description": "clocks with minute overflow by several days",
          "property": "equal",
          "clock1": {
            "hour": 2,
            "minute": 2
          },
          "clock2": {
            "hour": 2,
            "minute": 4322
          },
          "expected": true
        },
        {
          "description": "clocks with negative minute",
          "property": "equal",
          "clock1": {
            "hour": 2,
            "minute": 40
          },
          "clock2": {
            "hour": 3,
            "minute": -20
          },
          "expected": true
        },
        {
          "description": "clocks with negative minute that wraps",
          "property": "equal",
          "clock1": {
            "hour": 4,
            "minute": 10
          },
          "clock2": {
            "hour": 5,
            "minute": -1490
          },
          "expected": true
        },
        {
          "description": "clocks with negative minute that wraps multiple times",
          "property": "equal",
          "clock1": {
            "hour": 6,
            "minute": 15
          },
          "clock2": {
            "hour": 6,
            "minute": -4305
          },
          "expected": true
        },
        {
          "description": "clocks with negative hours and minutes",
          "property": "equal",
          "clock1": {
            "hour": 7,
            "minute": 32
          },
          "clock2": {
            "hour": -12,
            "minute": -268
          },
          "expected": true
        },
        {
          "description": "clocks with negative hours and minutes that wrap",
          "property": "equal",
          "clock1": {
            "hour": 18,
            "minute": 7
          },
          "clock2": {
            "hour": -54,
            "minute": -11513
          },
          "expected": true
        }
      ]
    }
  ]
}

END
}
