#!/usr/bin/perl
use Test::More 'no_plan';
use lib qw /lib/;
use MKDoc::Text::Structured;
use strict;


my $text = <<EOF;
paragraph one

*strong text* yey

paragraph two
EOF

my $res = MKDoc::Text::Structured::process ($text);

like ($res, qr/<div><p>paragraph one<\/p>/);
like ($res, qr/<p><strong>strong text<\/strong> yey<\/p>/);
like ($res, qr/<p>paragraph two<\/p><\/div>/);

__END__
