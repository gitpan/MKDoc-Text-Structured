#!/usr/bin/perl
use Test::More 'no_plan';
use lib qw /lib/;
use MKDoc::Text::Structured;
use strict;


my $text = <<EOF;
paragraph one

  some indented text

paragraph two

  some more
  pre text
    whyaglaaaa
sdfjsdkfl


EOF

my $res = MKDoc::Text::Structured::process ($text);

like ($res, qr/<p>paragraph one<\/p>/);
like ($res, qr/<pre>some indented text<\/pre>/);
like ($res, qr/<p>paragraph two<\/p>/);
like ($res, qr/<pre>some more/);
like ($res, qr/pre text/);
like ($res, qr/  whyaglaaaa<\/pre>/);
like ($res, qr/<p>sdfjsdkfl<\/p>/);

__END__
