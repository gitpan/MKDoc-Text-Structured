package MKDoc::Text::Structured::Inline;
use warnings;
use strict;

our $Text    = '';


sub process
{
    local $Text;
    $Text = shift;
    
    $Text   =  " $Text ";
    $Text   =~ s/&/&amp;/g;
    $Text   =~ s/</&lt;/g;
    $Text   =~ s/>/&gt;/g;

    _make_strong();
    _make_em();

    $Text =~ s/^ //;
    $Text =~ s/ $//;
    return $Text;
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
