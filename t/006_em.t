use warnings;
use strict;
use Test::More 'no_plan';
use lib qw (lib ../lib);
use MKDoc::Text::Structured;

my $text = <<EOF;
This is _strong text_
EOF

my $res = MKDoc::Text::Structured::process ($text);
like ($res, qr#<p>This is <em>strong text</em></p>#);

1;

__END__
