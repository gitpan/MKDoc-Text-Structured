#!/usr/bin/perl
use Test::More 'no_plan';
use lib qw /lib/;
use MKDoc::Text::Structured;
use strict;


my $text = <<EOF;
This is a test.

Orange:
  Round fruit with orange color

Banana:
  Long bend fruit with yellow color

Apple:
  Round crunchy fruit with green, yellow or red color

End of test.
EOF

my $res = MKDoc::Text::Structured::process ($text);

like ($res, qr/<dl>/);
like ($res, qr/<dt>Orange<\/dt>/);
like ($res, qr/<dd>Round fruit with orange color<\/dd>/);
like ($res, qr/<dt>Banana<\/dt>/);
like ($res, qr/<dd>Long bend fruit with yellow color<\/dd>/);
like ($res, qr/<dt>Apple<\/dt>/);
like ($res, qr/<dd>Round crunchy fruit with green, yellow or red color<\/dd>/);
like ($res, qr/<\/dl>/);


__END__
