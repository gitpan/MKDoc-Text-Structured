#!/usr/bin/perl
use Test::More 'no_plan';
use lib qw /lib/;
use MKDoc::Text::Structured;
use strict;

$MKDoc::Text::Structured::Text = <<EOF;

============
Hello, World
============

EOF

MKDoc::Text::Structured::_make_h1();
my $res = $MKDoc::Text::Structured::Text;

like ($res, qr/<h1>Hello, World<\/h1>/);
unlike ($res, qr/===/);
