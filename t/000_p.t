#!/usr/bin/perl
use Test::More 'no_plan';
use lib qw /lib/;
use MKDoc::Text::Structured;
use strict;

$MKDoc::Text::Structured::Text = <<EOF;


Muse!  When we learned to
count, little did we know all
the things we could do

some day by shuffling
those numbers: Pythagoras
said "All is number"

long before he saw
computers and their effects,
or what they could do


EOF

MKDoc::Text::Structured::_make_p();

my $one = qr /<p>Muse!  When we learned to
count, little did we know all
the things we could do<\/p>/;

my $two = qr/<p>some day by shuffling
those numbers: Pythagoras
said "All is number"<\/p>/;

my $three = qr/<p>long before he saw
computers and their effects,
or what they could do<\/p>/;


like ($MKDoc::Text::Structured::Text, $one);
like ($MKDoc::Text::Structured::Text, $two);
like ($MKDoc::Text::Structured::Text, $three);


__END__
