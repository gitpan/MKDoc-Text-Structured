#!/usr/bin/perl
use Test::More 'no_plan';
use lib qw /lib/;
use MKDoc::Text::Structured;
use strict;

$MKDoc::Text::Structured::Text = <<EOF;
Test test

1. this
2. is a
3. test

Stuff stuff

12343254. this

345342534. is

435234. another one
EOF

MKDoc::Text::Structured::_make_ol();

like ($MKDoc::Text::Structured::Text, qr/<ol>/);
like ($MKDoc::Text::Structured::Text, qr/<li>this<\/li>/);
like ($MKDoc::Text::Structured::Text, qr/<li>is a<\/li>/);
like ($MKDoc::Text::Structured::Text, qr/<li>test<\/li>/);
like ($MKDoc::Text::Structured::Text, qr/<li>another one<\/li>/);
like ($MKDoc::Text::Structured::Text, qr/<\/ol>/);


__END__
