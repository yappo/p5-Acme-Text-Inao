package Acme::Text::Inao::HTML;
use strict;
use warnings;
use base 'Acme::Text::Inao::WalkerBase';

sub _line {
    my($self, $prefix, $items) = @_;
    join '', '<P>', $prefix, $self->stack_walker($items), '</P>', "\n";
}

sub _head_base {
    my($self, $name, $text) = @_;
    join '', '<', $name, '>', $text, '</', $name, '>', "\n";
}

sub _list {
    my($self, $items, $text) = @_;
    join '', '<PRE>', $self->stack_walker($items), $text, '</PRE>', "\n";
}

sub _ul {
    my($self, $items) = @_;
    join '', '<UL>', $self->stack_walker($items), '</UL>', "\n";
}
sub _li {
    my($self, $text) = @_;
    join '', '<LI>', $text, '</LI>';
}

sub _tag_body {
    my($self, $tag, $items) = @_;
    join '', "<$tag>", $self->stack_walker($items), "</$tag>";
}
sub _tag_ruby {
    my($self, $word, $ruby) = @_;
    join '', $self->stack_walker($word), '(', $self->stack_walker($ruby), ')';
}
sub _tag_caption {
    my($self, $items) = @_;
    join '', '(', $self->stack_walker($items), ')';
}

sub _chars {
    my($self, $text) = @_;
    $text;
}

1;
