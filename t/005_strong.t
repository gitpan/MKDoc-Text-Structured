#!/usr/bin/perl
use Test::More 'no_plan';
use lib qw /lib/;
use MKDoc::Text::Structured;
use strict;

$MKDoc::Text::Structured::Text = <<EOF;
Test test
*this is a test!*
test
EOF

MKDoc::Text::Structured::_make_strong();
like ($MKDoc::Text::Structured::Text, qr/<strong>this is a test\!<\/strong>/);


__END__
