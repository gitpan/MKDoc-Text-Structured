#!/usr/bin/perl
use Test::More 'no_plan';
use lib qw /lib/;
use MKDoc::Text::Structured;
use strict;


my $text = <<EOF;
* one
  * one - one
  * one - two
    1. one
    2. two
    2. three
  * one - three
* two
* three
  1. three - one
  2. three - two
  3. three - three
* four 
EOF

my $expected = <<EOF;
<ul>
<li>one
<ul>
<li>one - one</li>
<li>one - two
<ol>
<li>one</li>
<li>two</li>
<li>three</li>
</ol>
</li>
<li>one - three</li>
</ul>
</li>
<li>two</li>
<li>three
<ol>
<li>three - one</li>
<li>three - two</li>
<li>three - three</li>
</ol>
</li>
<li>four </li>
</ul>
EOF

my $res = MKDoc::Text::Structured::process ($text);
# print $res;
ok (1);


__END__
