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

　ということでテストとおるかな。
";

my $expected = "<H1>一段落</H1>
<P>　さっそく始まりましたこのコーナー、注目は以下の三項目です。</P>
<UL><LI>パース出来れば、フォーマット的にはOK</LI><LI>なんとHTMLも出力する</LI><LI>文体のチェックしたい！</LI><LI>ザックリと書いた行数を誌面ベースで計算してほしい！</LI><LI>英単語の前後にスペースあったら警告したいね</LI></UL>
<P>　とかとかそういう感じです。使い方は以下の通りなんです。</P>
<PRE>use Acme::Text::Inao;
my \$html = Acme::Text::Inao->new->from_inao(\$genko)->to_html;</PRE>
<P>　どうです？簡単でしょ。</P>
<H2>二段落-1</H2>
<P>　うーん。ここになにかこうかな。</P>
<H3>三段落</H3>
<P>　うぎゃーす。</P>
<H2>二段落-2</H2>
<P>　どうしよう。さてさて。</P>
<PRE>sleep 100000000000;</PRE>
<P>　ということでテストとおるかな。</P>
";

is $inao->from_inao($text)->to_html, $expected;

done_testing;
