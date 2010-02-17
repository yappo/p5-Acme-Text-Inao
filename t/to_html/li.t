use strict;
use warnings;
use utf8;
use Test::More;
use Acme::Text::Inao;

my $square  = "\x{25a0}";
my $rhombus = "\x{25c6}";
my $li_dot  = "\x{30fb}";

sub run_tests {
    my($text, $expected) = @_;
}

my $inao = Acme::Text::Inao->new( parser_start => 'ul' );

subtest 'normal' => sub {
    my $text     = "\n${li_dot}リストだよ\n";
    my $expected = "<UL><LI>リストだよ</LI></UL>\n";
    is $inao->from_inao($text)->to_html, $expected;

    $text     = "\n${li_dot}リスト1だよ\n${li_dot}リスト2だよ\n";
    $expected = "<UL><LI>リスト1だよ</LI><LI>リスト2だよ</LI></UL>\n";
    is $inao->from_inao($text)->to_html, $expected;

    $text     = "\n${li_dot}リスト1だよ\n${li_dot}${rhombus}b/${rhombus}タグ記号を含めるよ${rhombus}/b${rhombus}\n${li_dot}リスト3だよ\n";
    $expected = "<UL><LI>リスト1だよ</LI><LI>${rhombus}b/${rhombus}タグ記号を含めるよ${rhombus}/b${rhombus}</LI><LI>リスト3だよ</LI></UL>\n";
    is $inao->from_inao($text)->to_html, $expected;

    done_testing;
};

done_testing;
