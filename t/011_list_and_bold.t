#!/usr/bin/perl
use Test::More 'no_plan';
use lib qw /lib/;
use MKDoc::Text::Structured;
use strict;


my $text = <<EOF;
* Hello, *I will not
* be bold*
* but
* *I will be*
EOF


my $res = MKDoc::Text::Structured::process ($text);
like ($res, qr/<ul>/);
like ($res, qr/<li>Hello, \*I will not<\/li>/);
like ($res, qr/<li>be bold\*<\/li/);
like ($res, qr/<li>but<\/li/);
like ($res, qr/<li><strong>I will be<\/strong><\/li/);
like ($res, qr/<\/ul>/);

__END__
