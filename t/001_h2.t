#!/usr/bin/perl
use Test::More 'no_plan';
use lib qw /lib/;
use MKDoc::Text::Structured;
use strict;

$MKDoc::Text::Structured::Text = <<EOF;

Hello, World
============

This is a Test
==============

This is a test, this is a test.

EOF

MKDoc::Text::Structured::_make_h2();

like ($MKDoc::Text::Structured::Text, qr/<h2>Hello, World<\/h2>/);
like ($MKDoc::Text::Structured::Text, qr/<h2>This is a Test<\/h2>\E/);
