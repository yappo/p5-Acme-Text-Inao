package Acme::Text::Inao::Status;
use strict;
use warnings;
use base 'Acme::Text::Inao::WalkerBase';

sub new {
    my $class = shift;
    bless {
        captions => 0,
        status   => {
            body_length => 0,
            length      => undef,
            lines       => 0,
            pages       => 0,
            raw_pages   => 0,
        },
    }, $class;
}

sub status { $_[0]->{status} }

sub add_length {
    my($self, $length) = @_;
    $self->{status}->{body_length} += $length;
    my $lines = int($length / 24) + 1;
    $self->add_lines($lines);
}
sub add_lines {
    my($self, $lines) = @_;
    $self->{status}->{lines} += $lines;
    $self->{status}->{pages}     = int((($self->{status}->{lines} + 24) / 90) * 100 ) / 100;
    $self->{status}->{raw_pages} = int(($self->{status}->{lines} / 90)        * 100 ) / 100;
}

sub _head1 { shift->add_lines(3) }
sub _head2 { shift->add_lines(2) }
sub _head3 { shift->add_lines(2) }
sub _column_head { shift->add_lines(2) }

sub _line {
    my($self, $prefix, $items) = @_;
    my $text = join '', $prefix, $self->stack_walker($items);
    $self->add_length(length $text);
}

sub _head_base {
    my($self, $name, $text) = @_;
    join '', '<', $name, '>', $text, '</', $name, '>', "\n";
}

sub _list {
    my($self, $items, $text) = @_;
    my @l = split "\n", join('', $self->stack_walker($items), $text);
    my $lines = scalar(@l);
    $self->add_lines($lines + 2);
}

sub _ul {
    my($self, $items) = @_;
    my @l = $self->stack_walker($items);
    my $lines = scalar(@l);
    $self->add_lines($lines + 2);
}
sub _li {
    my($self, $text) = @_;
    $text;
}

sub _tag_body {
    my($self, $tag, $items) = @_;
    join '', $self->stack_walker($items);
}
sub _tag_ruby {
    my($self, $word, $ruby) = @_;
    join '', $self->stack_walker($word), $self->stack_walker($ruby);
}
sub _tag_caption {
    my($self, $items) = @_;
    my $captions = ++$self->{captions};
    "注$captions";
}

sub _chars {
    my($self, $text) = @_;
    $text;
}

1;
