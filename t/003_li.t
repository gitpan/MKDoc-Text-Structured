#!/usr/bin/perl
use Test::More 'no_plan';
use lib qw /lib/;
use MKDoc::Text::Structured;
use strict;

$MKDoc::Text::Structured::Text = <<EOF;
Test test

* this
* is a
* test

Stuff stuff

* this

* is

* another one
EOF

MKDoc::Text::Structured::_make_ul();

like ($MKDoc::Text::Structured::Text, qr/<ul>/);
like ($MKDoc::Text::Structured::Text, qr/<li>this<\/li>/);
like ($MKDoc::Text::Structured::Text, qr/<li>is a<\/li>/);
like ($MKDoc::Text::Structured::Text, qr/<li>test<\/li>/);
like ($MKDoc::Text::Structured::Text, qr/<li>another one<\/li>/);
like ($MKDoc::Text::Structured::Text, qr/<\/ul>/);


__END__
