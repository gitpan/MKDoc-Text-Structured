#!/usr/bin/perl
use Test::More 'no_plan';
use lib qw /lib/;
use MKDoc::Text::Structured;
use strict;


my $text = <<EOF;
List carriage return test
-------------------------

Hello *stuff /stuff stuff* stuff/

Hello *stuff /emphasize/ stuff*

EOF

my $res = MKDoc::Text::Structured::process ($text);

like ($res, qr/<p>Hello <strong>stuff \/stuff stuff<\/strong> stuff\/<\/p>/);


__END__
