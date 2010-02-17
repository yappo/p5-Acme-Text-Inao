package Acme::Text::Inao;
use strict;
use warnings;
our $VERSION = '0.01';

use Data::Dumper;
use Parse::RecDescent;

my $square = "\x{25a0}";

use utf8;
$::RD_HINT = 1;
#$::RD_TRACE = 1;
$::RD_WARN = sub { warn Dumper(\@_) };
$Parse::RecDescent::skip = '';

my $_inao_syntax = q(
    body       : section(s)     { warn "aaa body"; warn Data::Dumper::Dumper(\@item); $return = $item[1] }
    section    : line(s)        { warn "aaa section"; warn Data::Dumper::Dumper(\@item); $return = $item[1] }
    paragraph  : line(s)                { \@item }
    line       : /\x{3000}[^\n]+\x{3002}/s "\\n"       { $return = $item[1] }
    aline       : SPACE phrase(s?)       { $return = $item[2] }
    phrase     : /^[^\x{3000}\x{3002}][^\x{3002}]+?/ { $return = $item[1] }
    char       : /./ { $return = $item[1] }
    SPACE      : /\x{3000}/ { warn "space"; $return = "SPACE" }
    MARU       : /\x{3002}/ { warn "MARU" ; $return = "MARU" }
    SQUARE     : /\x{25a0}/     { warn "bbb" }
);

my $inao_syntax = q(
    paragraph  : line(s)                               { $return = { data => [ @item ] } }
    line       : brank
               | SPACE phrase(s?) LF                   { $return = { data => [ $item[0], $item[1], $item[2] ] } }
    brank      : LF                                    { $return = { data => [ @item ] } }
    phrase     : tag_phrase(s)                         { $return = { data => [ @item ] } }
               | semi_phrase(s)                        { $return = { data => [ @item ] } }
    tag_phrase : chars(s) tag_body      { $return = { data => [ @item ] } }
    semi_phrase: chars(s) MARU                            { $return = { data => [ @item ] } }
               | chars(s) TEN                             { $return = { data => [ @item ] } }
    chars      : /[^\x{3000}-\x{3002}\x{25c6}]+/               { $return = { data => [ @item ] } }

    tag_body: tag_start_B tag_body_phrase(s) tag_end_B     { $return = { data => [ $item[0], 'B', $item[2] ] } }
            | tag_start_I tag_body_phrase(s) tag_end_I     { $return = { data => [ $item[0], 'I', $item[2] ] } }
            | tag_start_CMD tag_body_phrase(s) tag_end_CMD     { $return = { data => [ $item[0], 'CMD', $item[2] ] } }

    tag_body_phrase: semi_phrase(s) { $return = { data => [ @item ] } }
                   | chars(s)       { $return = { data => [ @item ] } }

    tag_start_B    : RHOMBUS 'b' SLASH RHOMBUS
    tag_end_B      : RHOMBUS SLASH  'b' RHOMBUS

    tag_start_I    : RHOMBUS 'i' SLASH RHOMBUS
    tag_end_I      : RHOMBUS SLASH  'i' RHOMBUS

    tag_start_CMD  : RHOMBUS 'cmd' SLASH RHOMBUS
    tag_end_CMD    : RHOMBUS SLASH  'cmd' RHOMBUS

    SPACE      : /\x{3000}/
    TEN        : /\x{3001}/
    MARU       : /\x{3002}/
    SQUARE     : /\x{25a0}/
    RHOMBUS    : /\x{25c6}/
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
#warn Dumper($self->{parsed});
#die;
    $self;
}

sub to_html {
    my $self = shift;
    my $html;
    return $self->_to_html_dispatcher($self->{parsed}->{data});
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
    my $html = '';
    for my $data (@{ $items }) {
        $html .= $self->_to_html_dispatcher($data->{data});
    }
    return $html;
    for my $data (@{ $items }) {
        if (ref($data)) {
        } else {
            $html .= join '', '<P>', $data, "</P>\n";
        }
    }
    $html;
}

sub _to_html_brank {
    "<BR />\n";
}

sub _to_html_line {
    my($self, $prefix, $items) = @_;
    my @htmls;
    for my $data (@{ $items }) {
        push @htmls, $self->_to_html_dispatcher($data->{data});
    }
    join '', '<P>', $prefix, @htmls, '</P>', "\n";
}

sub _to_html_phrase {
    my($self, $items) = @_;
    my @htmls;
    for my $data (@{ $items }) {
        push @htmls, $self->_to_html_dispatcher($data->{data});
    }
    join '', @htmls;
}

sub _to_html_semi_phrase {
    my($self, $items, $suffix) = @_;
    my @htmls;
    for my $data (@{ $items }) {
        push @htmls, $self->_to_html_dispatcher($data->{data});
    }
    join '', @htmls, $suffix;
}

sub _to_html_tag_phrase {
    my($self, $prefix, $items) = @_;
    my @htmls;
    for my $data (@{ $prefix }) {
        push @htmls, $self->_to_html_dispatcher($data->{data});
    }
    push @htmls, $self->_to_html_dispatcher($items->{data});
    join '', @htmls;
}

sub _to_html_tag_body {
    my($self, $tag, $items) = @_;
    my @htmls;
    for my $data (@{ $items }) {
        push @htmls, $self->_to_html_dispatcher($data->{data});
    }
    join '', "<$tag>", @htmls, "</$tag>";
}

sub _to_html_tag_body_phrase {
    my($self, $items) = @_;
    my @htmls;
    for my $data (@{ $items }) {
        push @htmls, $self->_to_html_dispatcher($data->{data});
    }
    join '', @htmls;
}

sub _to_html_chars {
    my($self, $text) = @_;
    $text;
}

1;

__END__

sub body {
    my($self, $items) = @_;
warn Dumper($items);
}

sub section {
    my($self, $items) = @_;
#warn Dumper($items);
}

sub head1 {
    my($self, $items) = @_;
warn Dumper($items, "head1");
}
sub section1 {
    my($self, $items) = @_;
warn Dumper($items, "section1");
}

sub head2 {
    my($self, $items) = @_;
warn Dumper($items, "head2");
}
sub section2 {
    my($self, $items) = @_;
warn Dumper($items, "section2");
}

sub head3 {
    my($self, $items) = @_;
warn Dumper($items, "head3");
}
sub section3 {
    my($self, $items) = @_;
warn Dumper($items, "section3");
}

sub head4 {
    my($self, $items) = @_;
warn Dumper($items, "head4");
}
sub column {
    my($self, $items) = @_;
warn Dumper($items, "column");
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
