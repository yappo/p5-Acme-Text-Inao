package Acme::Text::Inao;
use strict;
use warnings;
our $VERSION = '0.01';

use Parse::RecDescent;

use utf8;
$::RD_HINT = 1;
#$::RD_TRACE = 1;
#$::RD_WARN = sub { warn Dumper(\@_) };
$Parse::RecDescent::skip = '';

my $inao_syntax = q(

    body    : sections(s)       { $return = { data => [ @item ] } }
    sections: section1(s)       { $return = { data => [ @item ] } }
            | column_section(s) { $return = { data => [ @item ] } }

    section1: head1 content1(s) { $return = { data => [ @item ] } }
    section2: head2 content2(s) { $return = { data => [ @item ] } }
    section3: head3 content3(s) { $return = { data => [ @item ] } }
    column_section:
              column_head column_content(s) { $return = { data => [ @item ] } }

    content1: section2(s)  { $return = { data => [ @item ] } }
            | paragraph(s) { $return = { data => [ @item ] } }
            | list(s)      { $return = { data => [ @item ] } }
            | ul(s)        { $return = { data => [ @item ] } }
    content2: section3(s)  { $return = { data => [ @item ] } }
            | paragraph(s) { $return = { data => [ @item ] } }
            | list(s)      { $return = { data => [ @item ] } }
            | ul(s)        { $return = { data => [ @item ] } }
    content3:
              paragraph(s) { $return = { data => [ @item ] } }
            | list(s)      { $return = { data => [ @item ] } }
            | ul(s)        { $return = { data => [ @item ] } }
    column_content:
              paragraph(s) { $return = { data => [ @item ] } }
            | list(s)      { $return = { data => [ @item ] } }
            | ul(s)        { $return = { data => [ @item ] } }

    head1: LF SQUARE    ...!SQUARE all_chars_without_lf LF { $return = { data => [ $item[0], $item[4] ] } }
    head2: LF SQUARE(2) ...!SQUARE all_chars_without_lf LF { $return = { data => [ $item[0], $item[4] ] } }
    head3: LF SQUARE(3) ...!SQUARE all_chars_without_lf LF { $return = { data => [ $item[0], $item[4] ] } }
    column_head:
           LF SQUARE(4) ...!SQUARE all_chars_without_lf LF { $return = { data => [ $item[0], $item[4] ] } }

    list     : tag_start_list list_body(s?) all_chars_without_lf tag_end_list
                   { $return = { data => [ $item[0], $item[2], $item[3] ] } }
    list_body: all_chars_without_lf ...!tag_end_list LF
                   {  $return = { data => [ $item[0], "$item[1]$item[3]" ] } }

    ul: li(s) LF                             { $return = { data => [ @item ] } }
    li: LF LI_DOT all_chars_without_lf ...LF { $return = { data => [ $item[0], $item[3] ] } }

    paragraph  : LF line(s)                            { $return = { data => [ $item[0], $item[2] ] } }
    line       : SPACE phrase(s?) LF                   { $return = { data => [ $item[0], $item[1], $item[2] ] } }
    phrase     : tag_phrase(s)                         { $return = { data => [ @item ] } }
               | semi_phrase(s)                        { $return = { data => [ @item ] } }
               | tags(s)                               { $return = { data => [ @item ] } }

    tag_phrase : chars(s) tags                         { $return = { data => [ @item ] } }
    semi_phrase: chars(s) MARU                         { $return = { data => [ @item ] } }
               | chars(s) TEN                          { $return = { data => [ @item ] } }
    chars      : /[^\x{3000}-\x{3002}\x{25c6}\n]+/     { $return = { data => [ @item ] } }
    all_chars_without_lf: /[^\n]+/

    tags    : tag_body      { $return = { data => [ @item ] } }
            | tag_caption   { $return = { data => [ @item ] } }
            | tag_ruby      { $return = { data => [ @item ] } }

    tag_body: tag_start_B tag_body_phrase(s) tag_end_B                 { $return = { data => [ $item[0], 'B', $item[2] ] } }
            | tag_start_I tag_body_phrase(s) tag_end_I                 { $return = { data => [ $item[0], 'I', $item[2] ] } }
            | tag_start_CMD tag_body_phrase(s) tag_end_CMD             { $return = { data => [ $item[0], 'CMD', $item[2] ] } }
    tag_ruby : tag_start_RUBY chars(s) RHOMBUS chars(s) tag_end_RUBY   { $return = { data => [ $item[0], $item[2], $item[4] ] } }
    tag_caption : tag_start_caption tag_body_phrase(s) tag_end_caption { $return = { data => [ $item[0], $item[2] ] } }

    tag_body_phrase: semi_phrase(s)              { $return = { data => [ @item ] } }
                   | chars(s)                    { $return = { data => [ @item ] } }
                   | tag_body_chars(s)           { $return = { data => [ @item ] } }

    tag_body_chars      : RHOMBUS tag_body_chars_base(s)   { $return = { data => [ @item ] } }
    tag_body_chars_base : /[^\x{25c6}\n\/]+/               { $return = { data => [ @item ] } }


    tag_start_B    : RHOMBUS 'b' SLASH RHOMBUS
    tag_end_B      : RHOMBUS SLASH  'b' RHOMBUS

    tag_start_I    : RHOMBUS 'i' SLASH RHOMBUS
    tag_end_I      : RHOMBUS SLASH  'i' RHOMBUS

    tag_start_CMD  : RHOMBUS 'cmd' SLASH RHOMBUS
    tag_end_CMD    : RHOMBUS SLASH  'cmd' RHOMBUS

    tag_start_caption    : RHOMBUS '注' SLASH RHOMBUS
    tag_end_caption      : RHOMBUS SLASH  '注' RHOMBUS

    tag_start_RUBY : RHOMBUS 'ルビ' SLASH RHOMBUS
    tag_end_RUBY   : RHOMBUS SLASH  'ルビ' RHOMBUS

    tag_start_list : LF RHOMBUS 'list' SLASH RHOMBUS LF
    tag_end_list   : LF RHOMBUS SLASH  'list' RHOMBUS LF

    SPACE      : /\x{3000}/
    TEN        : /\x{3001}/
    MARU       : /\x{3002}/
    SQUARE     : /\x{25a0}/
    RHOMBUS    : /\x{25c6}/
    LI_DOT     : /\x{30fb}/
    SLASH      : /\//
    LF         : /\n/

);

sub new {
    my($class, %args) = @_;
    bless { text => '', parser_skip => '', %args }, $class;
}

sub from_inao {
    my($self, $text) = @_;
    my $parser = Parse::RecDescent->new($inao_syntax);
    my $start = $self->{parser_start} || 'body';
    local $Parse::RecDescent::skip = $self->{parser_skip};

    $self->{parsed} = $parser->$start($text);
    $self;
}

sub to_html {
    my $self = shift;
    my $html;
    return $self->_to_html_dispatcher($self->{parsed}->{data});
}

sub stack_walker {
    my($self, $items) = @_;
    my @results;
    for my $data (@{ $items }) {
        push @results, $self->_to_html_dispatcher($data->{data});
    }
    @results;
}

sub _to_html_dispatcher {
    my($self, $item) = @_;
    $item = [ $item ] unless ref($item) eq 'ARRAY';
    my @items = @{ $item };
    my $name = shift @items;
    $name = "_to_html_$name";
    $self->$name(@items);
}

sub _to_html_paragraph {
    my($self, $items) = @_;
    join '', $self->stack_walker($items);
}

sub _to_html_line {
    my($self, $prefix, $items) = @_;
    join '', '<P>', $prefix, $self->stack_walker($items), '</P>', "\n";
}

sub _to_html_body {
    my($self, $items) = @_;
    join '', $self->stack_walker($items);
}
sub _to_html_sections {
    my($self, $items) = @_;
    join '', $self->stack_walker($items);
}

sub _to_html_section1 {
    my($self, $head, $items) = @_;
    join '', $self->_to_html_dispatcher($head->{data}), $self->stack_walker($items);
}
sub _to_html_content1 {
    my($self, $items) = @_;
    join '', $self->stack_walker($items);
}
sub _to_html_section2 {
    my($self, $head, $items) = @_;
    join '', $self->_to_html_dispatcher($head->{data}), $self->stack_walker($items);
}
sub _to_html_content2 {
    my($self, $items) = @_;
    join '', $self->stack_walker($items);
}
sub _to_html_section3 {
    my($self, $head, $items) = @_;
    join '', $self->_to_html_dispatcher($head->{data}), $self->stack_walker($items);
}
sub _to_html_content3 {
    my($self, $items) = @_;
    join '', $self->stack_walker($items);
}
sub _to_html_column_section {
    my($self, $head, $items) = @_;
    join '', $self->_to_html_dispatcher($head->{data}), $self->stack_walker($items);
}
sub _to_html_column_content {
    my($self, $items) = @_;
    join '', $self->stack_walker($items);
}

sub _to_html_head1 {
    my($self, $text) = @_;
    join '', '<H1>', $text, '</H1>', "\n";
}
sub _to_html_head2 {
    my($self, $text) = @_;
    join '', '<H2>', $text, '</H2>', "\n";
}
sub _to_html_head3 {
    my($self, $text) = @_;
    join '', '<H3>', $text, '</H3>', "\n";
}
sub _to_html_column_head {
    my($self, $text) = @_;
    join '', '<H1>', $text, '</H1>', "\n";
}

sub _to_html_list {
    my($self, $items, $text) = @_;
    join '', '<PRE>', $self->stack_walker($items), $text, '</PRE>', "\n";
}
sub _to_html_list_body {
    my($self, $text) = @_;
    $text;
}

sub _to_html_ul {
    my($self, $items) = @_;
    join '', '<UL>', $self->stack_walker($items), '</UL>', "\n";
}

sub _to_html_li {
    my($self, $text) = @_;
    join '', '<LI>', $text, '</LI>';
}

sub _to_html_phrase {
    my($self, $items) = @_;
    join '', $self->stack_walker($items);
}

sub _to_html_semi_phrase {
    my($self, $items, $suffix) = @_;
    join '', $self->stack_walker($items), $suffix;
}

sub _to_html_tag_phrase {
    my($self, $prefix, $items) = @_;
    my @htmls;
    push @htmls, $self->stack_walker($prefix);
    push @htmls, $self->_to_html_dispatcher($items->{data});
    join '', @htmls;
}

sub _to_html_tags {
    my($self, $items) = @_;
    join '', $self->_to_html_dispatcher($items->{data});
}

sub _to_html_tag_body {
    my($self, $tag, $items) = @_;
    join '', "<$tag>", $self->stack_walker($items), "</$tag>";
}

sub _to_html_tag_ruby {
    my($self, $word, $ruby) = @_;
    join '', $self->stack_walker($word), '(', $self->stack_walker($ruby), ')';
}

sub _to_html_tag_caption {
    my($self, $items) = @_;
    join '', '(', $self->stack_walker($items), ')';
}

sub _to_html_tag_body_chars {
    my($self, $rhombus, $items) = @_;
    join '', $rhombus, $self->stack_walker($items);
}

sub _to_html_tag_body_chars_base {
    my($self, $text) = @_;
    $text;
}

sub _to_html_tag_body_phrase {
    my($self, $items) = @_;
    join '', $self->stack_walker($items);
}

sub _to_html_chars {
    my($self, $text) = @_;
    $text;
}

1;
__END__

=head1 NAME

Acme::Text::Inao -

=head1 SYNOPSIS

  use Acme::Text::Inao;

=head1 DESCRIPTION

Acme::Text::Inao is

=head1 AUTHOR

Default Name E<lt>default {at} example.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
