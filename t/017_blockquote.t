#!/usr/bin/perl
use Test::More 'no_plan';
use lib qw /lib/;
use MKDoc::Text::Structured;
use strict;


my $text = <<EOF;
This is a test.

> > Hi, I have been wondering if you were doing stuff
> Sure I am!

Cool.

> What about stuff?
>> Stuff?
> > Stuff.
>> > Stuff!
> Blah
> > > Blah
Yoyodine

EOF

my $res = MKDoc::Text::Structured::process ($text);

like ($res, qr/<p>This is a test.<\/p>/);
like ($res, qr/<blockquote>/);
like ($res, qr/<blockquote>/);
like ($res, qr/Hi, I have been wondering if you were doing stuff<\/blockquote>/);
like ($res, qr/<p>Sure I am!<\/blockquote><\/p>/);
like ($res, qr/<p>Cool.<\/p>/);
like ($res, qr/<blockquote>/);
like ($res, qr/What about stuff?/);
like ($res, qr/<blockquote>/);
like ($res, qr/Stuff?/);
like ($res, qr/Stuff./);
like ($res, qr/<blockquote>/);
like ($res, qr/Stuff!<\/blockquote>/);
like ($res, qr/<\/blockquote>/);
like ($res, qr/<p>Blah<\/p>/);
like ($res, qr/<blockquote>/);
like ($res, qr/<blockquote>/);
like ($res, qr/Blah<\/blockquote>/);
like ($res, qr/<\/blockquote>/);
like ($res, qr/<\/blockquote>/);
like ($res, qr/<p>Yoyodine<\/p>/);


__END__
