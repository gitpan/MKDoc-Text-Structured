use lib qw (lib ..\/lib);
use MKDoc::Text::Structured;
use strict;
use warnings;

my $text = join '', <STDIN>;
print MKDoc::Text::Structured::process ($text);
