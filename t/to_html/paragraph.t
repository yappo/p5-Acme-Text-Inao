use strict;
use warnings;
use utf8;
use Test::More;
use Acme::Text::Inao;

use Data::Dumper;warn Dumper("◆");

my $square  = "\x{25a0}";
my $rhombus = "\x{25c6}";

sub run_tests {
    my($text, $expected) = @_;
}

my $inao = Acme::Text::Inao->new( parser_start => 'paragraph' );

subtest 'パラグラフ1個' => sub {
    my $text     = "　文章だよ。\n";
    my $expected = "<P>　文章だよ。</P>\n";
    is $inao->from_inao($text)->to_html, $expected;
    done_testing;
};

subtest 'パラグラフ3個' => sub {
    my $text     = "　文章の頭のテスト。ここから改行です。はい。パラグラフは行末が。で終わらないといけませんが、行頭は全角空白で始まる必要があります。
　その他にも空行は認められません。
　さんぎょうめだよ。
";

    my $expected = "<P>　文章の頭のテスト。ここから改行です。はい。パラグラフは行末が。で終わらないといけませんが、行頭は全角空白で始まる必要があります。</P>
<P>　その他にも空行は認められません。</P>
<P>　さんぎょうめだよ。</P>
";
    is $inao->from_inao($text)->to_html, $expected;
    done_testing;
};

subtest 'パラグラフ2個 空行混み' => sub {
    my $text     = "　文章の頭のテスト。ここから改行です。はい。パラグラフは行末が。で終わらないといけませんが、行頭は全角空白で始まる必要があります。

　さんぎょうめだよ。
";

    my $expected = "<P>　文章の頭のテスト。ここから改行です。はい。パラグラフは行末が。で終わらないといけませんが、行頭は全角空白で始まる必要があります。</P>
<BR />
<P>　さんぎょうめだよ。</P>
";
    is $inao->from_inao($text)->to_html, $expected;
    done_testing;
};

subtest 'タグ付きパラグラフ' => sub {
    my $text     = "　文章の${rhombus}b/${rhombus}強調している、文章なんです。${rhombus}/b${rhombus}だよ。\n";
    my $expected = "<P>　文章の<B>強調している、文章なんです。</B>だよ。</P>\n";
    is $inao->from_inao($text)->to_html, $expected;

    my $text     = "　文章の${rhombus}b/${rhombus}強調${rhombus}/b${rhombus}だよ。\n";
    my $expected = "<P>　文章の<B>強調</B>だよ。</P>\n";
    is $inao->from_inao($text)->to_html, $expected;
    done_testing;
};

done_testing;

