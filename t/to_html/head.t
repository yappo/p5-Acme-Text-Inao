use strict;
use warnings;
use utf8;
use Test::More;
use Acme::Text::Inao;

my $square = "\x{25a0}";

sub run_tests {
    my($text, $expected) = @_;
}

my $text     = "
${square}foo
text1
${square}${square}bar
text2
${square}${square}${square}baz
text3
${square}${square}${square}${square}column
column
${square}foo2
text12
";
my $expected = "
<H1>foo</H1>
<P>text1</P>
<H2>bar</H2>
<P>text2</P>
<H3>baz</H3>
<P>text3</P>
<H4>column</H4>
<P>column</P>
";
my $inao = Acme::Text::Inao->new->parse($text);
#is $inao->to_html, $expected, $expected;

done_testing;

