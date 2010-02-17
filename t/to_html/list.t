use strict;
use warnings;
use utf8;
use Test::More;
use Acme::Text::Inao;

my $square  = "\x{25a0}";
my $rhombus = "\x{25c6}";

sub run_tests {
    my($text, $expected) = @_;
}

my $inao = Acme::Text::Inao->new( parser_start => 'list' );

subtest 'list' => sub {
    my $text     = "\n${rhombus}list/${rhombus}\nsub foo{\n   die;\n}\n${rhombus}/list${rhombus}\n";
    my $expected = "<PRE>sub foo{\n   die;\n}</PRE>\n";
    is $inao->from_inao($text)->to_html, $expected;

    $text     = "\n${rhombus}list/${rhombus}\n${rhombus}b/${rhombus}タグ記号を含めるよ${rhombus}/b${rhombus}\n${rhombus}/list${rhombus}\n";
    $expected = "<PRE>${rhombus}b/${rhombus}タグ記号を含めるよ${rhombus}/b${rhombus}</PRE>\n";

    $text     = "\n${rhombus}list/${rhombus}\nはじめ${rhombus}b/${rhombus}タグ記号を含めるよ${rhombus}/b${rhombus}\n${rhombus}b/${rhombus}タグ記号を\n含めるよ${rhombus}/b${rhombus}\n${rhombus}b/${rhombus}タグ記号を含めるよ${rhombus}/b${rhombus}おわり\n${rhombus}/list${rhombus}\n";
    $expected = "<PRE>はじめ${rhombus}b/${rhombus}タグ記号を含めるよ${rhombus}/b${rhombus}\n${rhombus}b/${rhombus}タグ記号を\n含めるよ${rhombus}/b${rhombus}\n${rhombus}b/${rhombus}タグ記号を含めるよ${rhombus}/b${rhombus}おわり</PRE>\n";

    is $inao->from_inao($text)->to_html, $expected;

    done_testing;
};

done_testing;
