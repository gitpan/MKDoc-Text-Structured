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
our $VERSION = 0.3;


sub process
{
    local $Text = shift;
    $Text =~ s/\r//g; # we like \n

    $Text = "\n\n$Text\n\n";
    $Text =~ s/&/&amp;/g;
    $Text =~ s/</&lt;/g;
    $Text =~ s/>/&gt;/g;
    $Text =~ s/\//&slash;/g;
    
    # block level stuff
    _make_h1();
    _make_h2();
    _make_h3();
    _make_lists();
    _make_blockquote();
    _make_dl();
    _make_pre();
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
    return "<div>$res</div>";
}


sub _make_blockquote
{
    while ($Text =~ s/((?:\n+\&gt\;.*)+)/_make_blockquote_wrap ($1)/e) {}
}

sub _make_blockquote_wrap
{
    my $stuff = shift;
    $stuff =~ s/\n+\&gt\;\s*/\n/g;
    local $Text = $stuff;
    _make_blockquote();
    return "\n\n<blockquote>$Text</blockquote>\n\n";
}


sub _make_dl
{

    while ($Text =~ s/
(                      # begin capture
(?:
  \n+.+?\:             #   ^line like this:
  (?:\n[ \t]+[^\n]+)+  #   ^  one or more lines like this 
)+                     # one or more times
)                      # end capture
/_make_dl_wrap ($1)/ex) {}

}


sub _make_dl_wrap
{
    my $stuff = shift;
    my @items = $stuff =~ /
  \n+(.+?)\:       #   ^line like this:
  (\n\s+.*)      #   ^  one or more lines like this
/xg;
   
    for (@items) { s/^(\s+|\n)+//; s/(\s+|\n)+$//; s/\s+/ /g }

    my @res = ();
    push @res, "\n\n<dl>\n";
    while (scalar @items)
    {
        my $dt = shift (@items);
        my $dd = shift (@items);
        push @res, "\n<dt>$dt</dt>\n";
        push @res, "\n<dd>$dd</dd>\n";
    }
    push @res, "\n</dl>\n";

    return join '', @res;
}


sub _make_pre
{
    my @lines = split "\n", $Text;
    my @res   = ();
    while (scalar @lines)
    {
        my $line = shift (@lines);
        $line =~ /^\s+\S/ or do {
            push @res, $line;
            next;
        };

        my ($indent) = $line =~ /^(\s+)\S/;
        my @pre = ();
        while ($line =~ s/^$indent//)
        {
            push @pre, $line;
            $line = shift (@lines);
        }

        my $pre = join "\n", @pre;
        push @res, "\n\n<pre>$pre</pre>\n\n";
        push @res, $line;
    }
    
    $Text = join "\n", @res;
    $Text = "\n\n$Text\n\n";
}


sub _make_h1
{
    while ($Text =~ s/\n\=\=\=+\s*\n(.+)\n\=\=\=+\s*\n/\n\n<h1>$1<\/h1>\n\n/) {}
}


sub _make_h2
{
    while ($Text =~ s/\n(.+)\n\=\=\=+\s*\n/\n\n<h2>$1<\/h2>\n\n/) {}
}


sub _make_h3
{
    while ($Text =~ s/\n(.+)\n\-\-\-+\s*\n/\n\n<h3>$1<\/h3>\n\n/) {}
}


sub _make_lists
{
    _make_ul();
    _make_ol();
}


sub _make_ul
{
    while ($Text =~ s/((?:\n+\*\s.*)+)/_make_ul_wrap ($1)/e) {}
}


sub _make_ul_wrap
{
    my $stuff = "\n" . shift() . "\n";
    $stuff =~ s/\n\*\s+/\n\n\* /g;
    
    my @stuff = split /\n\n+/, $stuff;

    for (@stuff)
    {
        /^\*\s/ || next;
        s/\n\s+/\n/g; 
        s/^\*\s/\n\n<li>/;
        s/$/<\/li>\n\n/;
    }

    $stuff = join '', @stuff;
    $stuff = _make_sublists ($stuff);
    return "\n\n<ul>\n\n$stuff\n\n</ul>\n\n";
}


sub _make_ol
{
    while ($Text =~ s/((?:\n+\d+\.\s+.*)+)/_make_ol_wrap ($1)/e) {}
}


sub _make_ol_wrap
{
    my $stuff = "\n" . shift() . "\n";
    $stuff =~ s/\n\d+\.\s+/\n\n1\. /g;
  
    my @stuff = split /\n\n+/, $stuff;

    for (@stuff)
    {
        /^\d+\.\s/ || next;
        s/\n\s+/\n/g; 
        s/^\d+\.\s/\n\n<li>/;
        s/$/<\/li>\n\n/;
    }
    $stuff = join '', @stuff;
    $stuff = _make_sublists ($stuff);
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


sub _make_sublists
{
    my $stuff  = shift;
    my @blocks = split /\n\n+/, $stuff;
    for (@blocks) { $_ =~ /^</ and do { $_ = "\n$_\n" } }

    $stuff = join "\n", @blocks;
    @blocks = split /\n\n+/, $stuff;

    my @res = ();
    while (scalar @blocks)
    {
        my $block = shift (@blocks);
        $block =~ /^</ or do {
            push @res, $block;
            next;
        };

        my $next_block = $blocks[0];
        $next_block and $next_block !~ /^</ or do {
            push @res, $block;
            next;
        };

        my ($indent) = $next_block =~ /\n(\s+)(?:\*|\d+\.)/;
        $indent || do {
            push @res, $block;
            next;
        };

        $next_block = "\n$next_block\n";
        while ($next_block =~ s/\n$indent(\*|\d+\.)/\n$1/) {}
 
        local $Text = $next_block;
        _make_lists();

        $block =~ s/<\/li>/$Text<\/li>/;
        push @res, $block;
	shift (@blocks);
    }

    return join "\n\n", @res;
}


1;


__END__


=head1 CONSTRUCTS


=head1 Titles

Titles are represented as follows:

    =========================
    This is a beautiful title
    =========================

Titles are transformed using <h1> tags:

    <h1>This is a beautiful title</h1>


=head2 Sections

Sections are represented as follows:

    This is a section
    =================

Sections are transformed using <h2> tags:

    <h2>This is a section</h2>


=head2 Sub-sections

Sub-sections are represented as follows:

    This is a sub-section
    ---------------------

Sub-sections are transformed using <h3> tags:

    <h3>This is a sub-section</h3>


=head2 Paragraphs

Paragraphs are made simply by separating two blocks of text
with a carriage return.

    This is a first paragraph which has lots of
    interesting stuff, including an exclusive outlook
    on things and other ghizmos.

    This is a second paragraph, which has more interesting
    stuff to say. It's very good, too.

Paragraphs are transformed using <p> tags.


=head2 Quoted text

Quoted blocks are used usually to quote somebody:

    This is a paragraph:

    > > Ahha! This is some nested quoted text!
    > > Cool huh?
    > Of course, this is not nested.
    This is another paragraph.

Quoted blocks are transformed using <blockquote> tags.
 

=head2 Preformatted text

Preformatted text is pretty much like written in text emails or
POD documentation.

    This is a paragraph.

        This is some <pre> text.
        I can do ASCII art in there and it'll work.
        Proof:
           -.-
            ^

    This is another paragraph.

Preformatted text is transformed using <pre> tags.


=head2 Definition lists

Definition lists can be constructed as follow.

    Orange:
      Round fruit with orange color
 
    Banana:
      Bent fruit with yellow color
 
    Apple:
      Round crunchy fruit with green,
      yellow or red color

They are transformed using <dl> <dt> and <dd> tags.


=head2 Ordered and unordered lists

Ordered lists and unordered lists can be constructed as follows:

    * An item
    * Another item
        1. A sub-item
        2. Another sub-item
        3. Yet another sub-item
    * Yet another item

They are transformed using <ul>, <ol> and <li> tags.


=head2 Strong / Bold

Bold portion of text can be constructed as follows:

    *This will appear in bold*.

Bold text is transformed using <strong> tags.

Note 1: The star character will act as a 'bold' marker only when:

- The "opening" star is preceded by whitespace or carriage return,

- The "closing" star is followed by whitespace or carriage return,
or punctuation immediately followed by whitespace or carriage return.

In other words, you can write 3*3*2 = 18 safely. The module tries to follow the
DWIM ("Do What I Mean") philosophy as much as possible.


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


=head2 Emphasis

To emphasize a portion of text, use the following construct:

    /This is an emphasized portion of text/.

Emphasis is transformed using <em> tags.

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
