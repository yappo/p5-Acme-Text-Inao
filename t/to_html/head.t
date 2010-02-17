use strict;
use warnings;
use utf8;
use Test::More;
use Acme::Text::Inao;

my $square = "\x{25a0}";


my $inao = Acme::Text::Inao->new( parser_start => 'head1' );
my $text     = "\n${square}タ${square}イトル${square}\n";
my $expected = "<H1>タ${square}イトル${square}</H1>\n";
is $inao->from_inao($text)->to_html, $expected;

$inao = Acme::Text::Inao->new( parser_start => 'head2' );
$text     = "\n${square}${square}タ${square}イトル${square}\n";
$expected = "<H2>タ${square}イトル${square}</H2>\n";
is $inao->from_inao($text)->to_html, $expected;

$inao = Acme::Text::Inao->new( parser_start => 'head3' );
$text     = "\n${square}${square}${square}タ${square}イトル${square}\n";
$expected = "<H3>タ${square}イトル${square}</H3>\n";
is $inao->from_inao($text)->to_html, $expected;

$inao = Acme::Text::Inao->new( parser_start => 'column_head' );
$text     = "\n${square}${square}${square}${square}コラム${square}タイトル\n";
$expected = "<H1>コラム${square}タイトル</H1>\n";
is $inao->from_inao($text)->to_html, $expected;

done_testing;

