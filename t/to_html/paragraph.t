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

my $inao = Acme::Text::Inao->new( parser_start => 'paragraph' );

subtest 'paragraph 1' => sub {
    my $text     = "　文章だよ。\n";
    my $expected = "<P>　文章だよ。</P>\n";
    is $inao->from_inao($text)->to_html, $expected;
    done_testing;
};

subtest 'paragraph 3' => sub {
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

subtest 'paragraph 2 with empty line' => sub {
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

subtest 'paragraph with tags' => sub {
    my $text     = "　文章の${rhombus}b/${rhombus}強調している、文章なんです。${rhombus}/b${rhombus}だよ。\n";
    my $expected = "<P>　文章の<B>強調している、文章なんです。</B>だよ。</P>\n";
    is $inao->from_inao($text)->to_html, $expected;

    $text     = "　文章の${rhombus}b/${rhombus}強調${rhombus}/b${rhombus}だよ。\n";
    $expected = "<P>　文章の<B>強調</B>だよ。</P>\n";
    is $inao->from_inao($text)->to_html, $expected;

    $text     = "　文章の${rhombus}b/${rhombus}強調に${rhombus}をまぜます${rhombus}/b${rhombus}だよ。\n";
    $expected = "<P>　文章の<B>強調に${rhombus}をまぜます</B>だよ。</P>\n";
    is $inao->from_inao($text)->to_html, $expected;

    $text     = "　文章の${rhombus}b/${rhombus}${rhombus}をまぜます${rhombus}/b${rhombus}だよ。\n";
    $expected = "<P>　文章の<B>${rhombus}をまぜます</B>だよ。</P>\n";
    is $inao->from_inao($text)->to_html, $expected;

    $text     = "　文章の${rhombus}i/${rhombus}イタリック${rhombus}/i${rhombus}だよ。\n";
    $expected = "<P>　文章の<I>イタリック</I>だよ。</P>\n";
    is $inao->from_inao($text)->to_html, $expected;

    $text     = "　文章の${rhombus}cmd/${rhombus}print \"hello!\\n\"${rhombus}/cmd${rhombus}だよ。\n";
    $expected = "<P>　文章の<CMD>print \"hello!\\n\"</CMD>だよ。</P>\n";
    is $inao->from_inao($text)->to_html, $expected;

    $text     = "　文章の${rhombus}ルビ/${rhombus}単語${rhombus}たんご${rhombus}/ルビ${rhombus}だよ。\n";
    $expected = "<P>　文章の単語(たんご)だよ。</P>\n";
    is $inao->from_inao($text)->to_html, $expected;

    done_testing;
};

subtest 'paragraph caption' => sub {
    my $text     = "　文章の${rhombus}注/${rhombus}ここは注約なんです${rhombus}/注${rhombus}だよ。\n";
    my $expected = "<P>　文章の(ここは注約なんです)だよ。</P>\n";
    is $inao->from_inao($text)->to_html, $expected;

    $text     = "　文章の${rhombus}注/${rhombus}注約に${rhombus}をまぜます。${rhombus}/注${rhombus}だよ。\n";
    $expected = "<P>　文章の(注約に${rhombus}をまぜます。)だよ。</P>\n";
    is $inao->from_inao($text)->to_html, $expected;

    done_testing;
};

done_testing;

