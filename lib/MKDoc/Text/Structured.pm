=head1 NAME

MKDoc::Text::Structured - Another Text to HTML module


=head1 SYNOPSIS

    my $text = some_structured_text();
    my $html = MKDoc::Text::Structured::process ($text);


=head1 SUMMARY

L<MKDoc::Text::Structured> is a library which allows very simple
text construct to be turned into HTML. These constructs are the ones
you would be using when writing a text email or newsgroup message.

L<MKDoc::Text::Structured> follows the KISS philosophy. Comparing with
similar modules which try to implement as many HTML constructs as possible,
this module is incredibly restrictive, minimalistic and conservative.

And in fact that's why we use it :)

=cut
package MKDoc::Text::Structured;
use strict;
use warnings;


our $Text    = '';
our $VERSION = 0.1;


sub process
{
    local $Text = shift;
    $Text =~ s/\r//g; # we like \n

    $Text = "\n\n$Text\n\n";
    $Text =~ s/&/&amp;/g;
    $Text =~ s/</&lt;/g;
    $Text =~ s/>/&gt;/g;
    $Text =~ s/\//&slash;/g;
    
    # at the moment we don't want to do anything
    # with whitespace following carriage returns
    # might change later.
    $Text =~ s/\n( |\t)+/\n/g;
    
    # block level stuff
    _make_h2();
    _make_h3();
    _make_li();
    _make_ol();
    _make_p();
    
    # split each block level

    my @res = ();

    my @blocks = split /\n\n+/, $Text;
    while (scalar @blocks)
    {
	my $block = shift (@blocks);
	$block         || next;
	$block =~ /</  || next;
	
	local $Text = $block;
	_make_strong();
	_make_em();
	push @res, $Text;
    }
    
    my $res = join "\n", @res;
    $res =~ s/&slash;/\//g;
    return $res;
}


# block level methods
sub _make_h2
{
    while ($Text =~ s/\n(.+)\n\=\=\=+\s*\n/\n\n<h2>$1<\/h2>\n\n/) {}
}


sub _make_h3
{
    while ($Text =~ s/\n(.+)\n\-\-\-+\s*\n/\n\n<h3>$1<\/h3>\n\n/) {}
}


sub _make_li
{
    while ($Text =~ s/((?:\n+\*\s*.*)+)/_make_li_wrap ($1)/e) {}
}


sub _make_li_wrap
{
    my $stuff = shift;
    while ( $stuff =~ s/\n+\*\s*(.*)/\n\n<li>$1<\/li>\n\n/ ) {}
    return "\n\n<ul>\n\n$stuff\n\n</ul>\n\n";
}


sub _make_ol
{
    while ($Text =~ s/((?:\n+\d+\.\s+.*)+)/_make_ol_wrap ($1)/e) {}
}


sub _make_ol_wrap
{
    my $stuff = shift;
    while ( $stuff =~ s/\n+\d+\.\s*(.*)/\n\n<li>$1<\/li>\n\n/ ) {}
    return "\n\n<ol>\n\n$stuff\n\n</ol>\n\n";
}


sub _make_p
{
    while ($Text =~ s/\n\n(?!\<)(\S.*?)\n\n/\n\n<p>$1<\/p>\n\n/s) {}
}


sub _make_strong
{
    $Text = join '', map {
	my $stuff = $_;
	$stuff = " $stuff ";
	while ($stuff =~ s/
(?<=(?:\s|\n))                            # must start with space or carriage return or >
\*                                        # star
(\S.*?\S)                                 # stuff to capture and emphasize
\*                                        # star
(?=(?:<|\s|\n|\p{IsPunct}(?:\s|\n|<)))    # must be followed by space, \n or (punctuation + space or \n)
/_make_strong_wrap ($1)/xes) {}
	
	$stuff =~ s/^ //;
	$stuff =~ s/ $//;
	$stuff;
    } _tokenize ($Text);
}


sub _make_strong_wrap
{
    my $stuff = shift;
    local $Text = $stuff;
    _make_em ($Text);
    return "<strong>$Text</strong>";
}


sub _make_em
{
    $Text = join '', map {
	my $stuff = $_;
	$stuff = " $stuff ";
	while ($stuff =~ s/
(?<=(?:\s|\n))                        # must start with space or carriage return
\&slash\;                             # &slash;
(\S.*?\S)                             # stuff to capture and emphasize
\&slash\;                             # &slash;
(?=(?:\s|\n|\p{IsPunct}(?:\s|\n)))    # must be followed by space, \n or (punctuation + space or \n)
/_make_em_wrap ($1)/xes) {}
	
	$stuff =~ s/^ //;
	$stuff =~ s/ $//;
	$stuff;
    } _tokenize ($Text);
    
    $Text = join '', map {
	my $stuff = $_;
	$stuff = " $stuff ";
	while ($stuff =~ s/
(?<=(?:\s|\n))                            # must start with space or carriage return
_                                         # underscore
(\S.*?\S)                                 # stuff to capture and emphasize
_                                         # underscore
(?=(?:<|\s|\n|\p{IsPunct}(?:\s|\n)))      # must be followed by space, \n or (punctuation + space or \n)
/_make_em_wrap ($1)/xes) {}

	$stuff =~ s/^ //;
	$stuff =~ s/ $//;
	$stuff;
    } _tokenize ($Text);
}


sub _make_em_wrap
{
    my $stuff = shift;
    local $Text = $stuff;
    _make_strong ($Text);
    return "<em>$Text</em>";
}


sub _tokenize
{
    my $text = shift;
    my @res  = $text =~ /([^<]+)|(<.+?>)/g;
    return grep { defined $_ } @res;
}


1;


__END__


=head1 CONSTRUCTS


=head2 Sections

Sections are represented as follows:

    This is a section
    =================

Which produces:

    <h2>This is a section</h2>

Note: There is no way to do H1 since this is used by MKDoc for the
title of the document.


=head2 Sub-sections

H3's are represented as follows:

    This is a sub-section
    ---------------------

Which produces:

    <h3>This is a sub-section</h3>


=head2 Paragraphs

Paragraphs are made simply by separating two blocks of text
with a carriage return.

    This is a first paragraph which has lots of
    interesting stuff, including an exclusive outlook
    on things and other ghizmos.

    This is a second paragraph, which has more interesting
    stuff to say. It's very good, too.

Would produce:

    <p>This is a first paragraph which has lots of
    interesting stuff, including an exclusive outlook
    on things and other ghizmos.</p>

    <p>This is a second paragraph, which has more interesting
    stuff to say. It's very good, too.</p>


=head2 Bulleted Lists

Bulleted lists can be constructed as follows:

    * An item
    * Another item
    * Yet another item

Which would produce:

    <ul>
      <li>An item</li>
      <li>Another item</li>
      <li>Yet another item</li>
    </ul>

Note: L<MKDoc::Text::Structured> does not support nested lists.
I have no idea on how to support this with the current implementation.
Patches are always welcome :)


=head2 Ordered Lists

Ordered lists can be constructed as follows:

    1. An item
    2. Another item
    3. Yet another item

Which would produce:

    <ol>
      <li>An item</li>
      <li>Another item</li>
      <li>Yet another item</li>
    </ol>

Note: Same remark as above.


=head2 Strong / Bold

Bold portion of text can be constructed as follows:

    *This will appear in bold*.

Will produce:

    <strong>This will appear in bold</strong>.


Note 1: If you do not want the star to act as a 'bold'
marker, you can do this using spacing. For example:

    * This will not appear in bold *
    3 * 3 = 9

Note 2: This can only work within one block level element.
It will not work across paragraphs or lists.

Example 1:

   * Hello, *I will not
   * be bold*
   * but
   * *I will be*

Example 2:

   This is a paragraph. *Nothing in this paragraph
   is going to be bold.

   Nor in this one*.


=head2 Emphasis / Italic

To emphasize a portion of text, use the following construct:

    /This is an emphasized portion of text/.

Same notes as for bold / strong apply.


=head2 Hyperlinks

L<MKDoc::Text::Structured> has *NOTHING* to do with automagic hyperlinking.

At a low level you can use L<MKDoc::XML::Tagger>, part of the L<MKDoc::XML>
distribution to do this.

Automagically hyperlinking HTML will be the job of another MKDoc module.
It is out of the scope of operation of this current module.


=head1 AUTHOR

Copyright 2003 - MKDoc Holdings Ltd.

Author: Jean-Michel Hiver <jhiver@mkdoc.com>

This module is free software and is distributed under the same license as Perl
itself. Use it at your own risk.


=head1 SEE ALSO

  Petal: http://search.cpan.org/author/JHIVER/Petal/
  MKDoc: http://www.mkdoc.com/

Help us open-source MKDoc. Join the mkdoc-modules mailing list:

  mkdoc-modules@lists.webarch.co.uk

=cut
