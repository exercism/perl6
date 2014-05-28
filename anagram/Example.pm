class Anagram {
    method match ($word, @words) {
        my @results;
        my $canonical = self!canonize($word);
        for @words -> $w {
            next if $w eq $word;
            my $try = self!canonize($w);
            if $try eq $canonical {
                @results.push: $w;
            }
        }
        @results;
    }

    method !canonize($str) {
        (($str.lc.split('')).sort).join('');
    }
}
