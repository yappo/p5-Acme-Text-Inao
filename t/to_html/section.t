use strict;
use warnings;
use utf8;
use Test::More;
use Acme::Text::Inao;

my $square  = "\x{25a0}";
my $rhombus = "\x{25c6}";
my $li_dot  = "\x{30fb}";


subtest 'head1' => sub {
    my $inao = Acme::Text::Inao->new( parser_start => 'section1' );

    my $text     = "\n${square}最初\n\n　文章が始まります。\n\n${li_dot}りすとです\n\n　本文です。\n\n${rhombus}list/${rhombus}\nコードです\n${rhombus}/list${rhombus}\n\n　おしまい。\n";
    my $expected = "<H1>最初</H1>\n<P>　文章が始まります。</P>\n<UL><LI>りすとです</LI></UL>\n<P>　本文です。</P>\n<PRE>コードです</PRE>\n<P>　おしまい。</P>\n";
    is $inao->from_inao($text)->to_html, $expected;

    done_testing;
};

subtest 'head2' => sub {
    my $inao = Acme::Text::Inao->new( parser_start => 'section2' );

    my $text     = "\n${square}${square}最初\n\n　文章が始まります。\n\n${li_dot}りすとです\n\n　本文です。\n\n${rhombus}list/${rhombus}\nコードです\n${rhombus}/list${rhombus}\n\n　おしまい。\n";
    my $expected = "<H2>最初</H2>\n<P>　文章が始まります。</P>\n<UL><LI>りすとです</LI></UL>\n<P>　本文です。</P>\n<PRE>コードです</PRE>\n<P>　おしまい。</P>\n";
    is $inao->from_inao($text)->to_html, $expected;

    done_testing;
};


subtest 'head3' => sub {
    my $inao = Acme::Text::Inao->new( parser_start => 'section3' );

    my $text     = "\n${square}${square}${square}最初\n\n　文章が始まります。\n\n${li_dot}りすとです\n\n　本文です。\n\n${rhombus}list/${rhombus}\nコードです\n${rhombus}/list${rhombus}\n\n　おしまい。\n";
    my $expected = "<H3>最初</H3>\n<P>　文章が始まります。</P>\n<UL><LI>りすとです</LI></UL>\n<P>　本文です。</P>\n<PRE>コードです</PRE>\n<P>　おしまい。</P>\n";
    is $inao->from_inao($text)->to_html, $expected;

    done_testing;
};


subtest 'column' => sub {
    my $inao = Acme::Text::Inao->new( parser_start => 'column_section' );

    my $text     = "\n${square}${square}${square}${square}最初\n\n　文章が始まります。\n\n${li_dot}りすとです\n\n　本文です。\n\n${rhombus}list/${rhombus}\nコードです\n${rhombus}/list${rhombus}\n\n　おしまい。\n";
    my $expected = "<H1>最初</H1>\n<P>　文章が始まります。</P>\n<UL><LI>りすとです</LI></UL>\n<P>　本文です。</P>\n<PRE>コードです</PRE>\n<P>　おしまい。</P>\n";
    is $inao->from_inao($text)->to_html, $expected;

    done_testing;
};

done_testing;
