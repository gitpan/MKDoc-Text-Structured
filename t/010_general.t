#!/usr/bin/perl
use Test::More 'no_plan';
use lib qw /lib/;
use MKDoc::Text::Structured;
use strict;


my $text = <<EOF;
The MKDoc::Text::Structured module
==================================

Reasonable
----------

* Supports simple lists
* Supports simple headers
* Supports paragraphs
* Supports strong and em

Efficient
---------

1. No crazy markup
2. Fast (just a bunch of regexes)

Description
-----------

The MKDoc::Text::Structured module is *very cool* because
it lets you write HTML like you would write email or newsgroup
articles.

No crazy markup, just the simple, basic stuff working, and
fast. Try it!
EOF

my $res = MKDoc::Text::Structured::process ($text);


like ($res, qr/<h2>The MKDoc::Text::Structured module<\/h2>/);
like ($res, qr/<h3>Reasonable<\/h3>/);
like ($res, qr/<ul>/);
like ($res, qr/<li>Supports simple lists<\/li>/);
like ($res, qr/<li>Supports simple headers<\/li>/);
like ($res, qr/<li>Supports paragraphs<\/li>/);
like ($res, qr/<li>Supports strong and em<\/li>/);
like ($res, qr/<\/ul>/);
like ($res, qr/<h3>Efficient<\/h3>/);
like ($res, qr/<ol>/);
like ($res, qr/<li>No crazy markup<\/li>/);
like ($res, qr/<li>Fast \(just a bunch of regexes\)<\/li>/);
like ($res, qr/<\/ol>/);
like ($res, qr/<h3>Description<\/h3>/);
like ($res, qr/<p>The MKDoc::Text::Structured module is <strong>very cool<\/strong> because/);
like ($res, qr/it lets you write HTML like you would write email or newsgroup/);
like ($res, qr/articles.<\/p>/);
like ($res, qr/<p>No crazy markup, just the simple, basic stuff working, and/);
like ($res, qr/fast. Try it!<\/p>/);

__END__
