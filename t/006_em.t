#!/usr/bin/perl
use Test::More 'no_plan';
use lib qw /lib/;
use MKDoc::Text::Structured;
use strict;


$MKDoc::Text::Structured::Text = <<EOF;
<p>&slash;this should be emphasized&slash;</p>
EOF

MKDoc::Text::Structured::_make_em();
like ($MKDoc::Text::Structured::Text, qr/<p><em>this should be emphasized<\/em><\/p>/);


$MKDoc::Text::Structured::Text = <<EOF;
Test test
&slash;this is a test!&slash;
test
EOF

MKDoc::Text::Structured::_make_em();
like ($MKDoc::Text::Structured::Text, qr/<em>this is a test\!<\/em>/);


$MKDoc::Text::Structured::Text = <<EOF;
Test test
_this is a test!_
test
EOF

MKDoc::Text::Structured::_make_em();
like ($MKDoc::Text::Structured::Text, qr/<em>this is a test\!<\/em>/);

$MKDoc::Text::Structured::Text = <<EOF;

http:&slash;&slash;www.foo.com&slash;welcome&slash;enter&slash;

http:&slash;&slash;www.foo.com&slash;welcome&slash;enter&slash;index.html

http:&slash;&slash;www.foo.com&slash;welcome&slash;enter&slash;.sitemap.html

&slash;http:&slash;&slash;www.foo.com&slash;welcome&slash;enter&slash;.sitemap.html&slash;

EOF

MKDoc::Text::Structured::_make_em();
like ($MKDoc::Text::Structured::Text, qr/http:&slash;&slash;www.foo.com&slash;welcome&slash;enter&slash;/);
like ($MKDoc::Text::Structured::Text, qr/http:&slash;&slash;www.foo.com&slash;welcome&slash;enter&slash;index.html/);
like ($MKDoc::Text::Structured::Text, qr/http:&slash;&slash;www.foo.com&slash;welcome&slash;enter&slash;.sitemap.html/);
like ($MKDoc::Text::Structured::Text, qr/<em>http:&slash;&slash;www.foo.com&slash;welcome&slash;enter&slash;.sitemap.html<\/em>/);

__END__
