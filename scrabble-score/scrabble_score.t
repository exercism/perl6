use v6;
use Test;
use lib './';

plan 10;

BEGIN { EVAL('use Example') }; pass 'Load module';
ok Scrabble.can('score'), 'Scrabble class has score() method';

my $scrabble = Scrabble.new();

is $scrabble.score(""),                 0,  "empty word scores 0";
is $scrabble.score(" \t\n"),            0,  "whitespace scores 0";
is $scrabble.score("a"),                1,  "a scores 1";
is $scrabble.score("f"),                4,  "f scores 4";
is $scrabble.score("street"),           6,  "street scores 6";
is $scrabble.score("alacrity"),         13, "alacrity scores 13";
is $scrabble.score("MULTIBILLIONAIRE"), 20, "MULTIBILLIONAIRE scores 20";
is $scrabble.score("quirky"),           22, "quirky scores 22";
