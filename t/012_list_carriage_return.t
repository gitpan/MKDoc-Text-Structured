#!/usr/bin/perl
use Test::More 'no_plan';
use lib qw /lib/;
use MKDoc::Text::Structured;
use strict;


my $text = <<EOF;
List carriage return test
-------------------------

* Hello
* World

* This is


* A



* Smoke test

hello, hello

stuff
more stuff
EOF


my $res = MKDoc::Text::Structured::process ($text);

like ($res, qr/<ul>/);
like ($res, qr/<li>Hello<\/li>/);
like ($res, qr/<li>World<\/li>/);
like ($res, qr/<li>This is<\/li>/);
like ($res, qr/<li>A<\/li>/);
like ($res, qr/<li>Smoke test<\/li>/);
like ($res, qr/<\/ul>/);
like ($res, qr/<p>hello, hello<\/p>/);
like ($res, qr/<p>stuff/);
like ($res, qr/more stuff<\/p>/);


__END__
