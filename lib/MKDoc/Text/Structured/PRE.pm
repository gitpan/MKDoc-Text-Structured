package MKDoc::Text::Structured::PRE;
use base qw /MKDoc::Text::Structured::Base/;
use MKDoc::Text::Structured::Inline;
use warnings;
use strict;


sub new
{
    my $class  = shift;
    my $line = shift;

    my ($indent) = $line =~ /^(\s+)/;
    return unless ($indent);

    my $self = $class->SUPER::new();
    $self->{indent} = $indent;
    return $self;
}


sub is_ok
{
    my $self = shift;
    my $line = shift;
    my $indent = $self->{indent};
    return $line =~ /^$indent/;
}


sub process
{
    my $self   = shift;
    my @lines  = @{$self->{lines}};
    my $indent = $self->{indent};
    my $text   = join "\n", map { s/^$indent//; $_ } @lines;
    $text = MKDoc::Text::Structured::Inline::process ($text);

    return "<pre>$text</pre>";
}


1;


__END__
