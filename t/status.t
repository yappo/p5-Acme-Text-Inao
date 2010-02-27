use strict;
use warnings;
use utf8;
use Test::More;
use Acme::Text::Inao;

my $square  = "\x{25a0}";
my $rhombus = "\x{25c6}";
my $li_dot  = "\x{30fb}";


my $inao = Acme::Text::Inao->new;

my $text     = "
${square}一段落

　さっそく始まりましたこのコーナー、注目は以下の三項目です。

${li_dot}パース出来れば、フォーマット的にはOK
${li_dot}なんとHTMLも出力する
${li_dot}文体のチェックしたい！
${li_dot}ザックリと書いた行数を誌面ベースで計算してほしい！
${li_dot}英単語の前後にスペースあったら警告したいね

　とかとかそういう感じです。使い方は以下の通りなんです。

${rhombus}list/${rhombus}
use Acme::Text::Inao;
my \$html = Acme::Text::Inao->new->from_inao(\$genko)->to_html;
${rhombus}/list${rhombus}

　どうです？簡単でしょ。

${square}${square}二段落-1

　うーん。ここになにかこうかな。

${square}${square}${square}三段落

　うぎゃーす。

${square}${square}二段落-2

　どうしよう。さてさて。

${rhombus}list/${rhombus}
sleep 100000000000;
${rhombus}/list${rhombus}

　ということでAcme::Text::Inaoのテストとおるかな。
";

#pc = 30c + 28c + 12c + 16c + 7c + 12c + 33c 
#pl = 2 + 2 + 1 + 1 + 1 + 1 + 1 = 9
#head = 3 + 2 + 2 + 2 = 9
#list = 5+2 = 7
#code = 1+2+ 2+2 = 7
#7+7+9+9

is_deeply $inao->from_inao($text)->to_status, {
    body_length => 30+28+12+16+7+12+33,
    length      => undef,
    lines       => 33,
    pages       => 0.66,
    raw_pages   => 0.39,
};

done_testing;
