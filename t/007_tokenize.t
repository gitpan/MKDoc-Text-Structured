#!/usr/bin/perl
use Test::More 'no_plan';
use lib qw /lib/;
use MKDoc::Text::Structured;
use strict;


my $text = <<EOF;
Hello, <stuff>this is a test</stuff>, Stuff.
EOF

chomp ($text);

my @tok = MKDoc::Text::Structured::_tokenize ($text);
is ($tok[0], 'Hello, ');
is ($tok[1], '<stuff>');
is ($tok[2], 'this is a test');
is ($tok[3], '</stuff>');
is ($tok[4], ', Stuff.');


__END__
