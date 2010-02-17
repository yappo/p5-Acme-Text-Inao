package Acme::Text::Inao::WalkerBase;
use strict;
use warnings;

sub new {
    my $class = shift;
    bless {}, $class;
}

sub walk {
    my($self, $item) = @_;
    $item = [ $item ] unless ref($item) eq 'ARRAY';
    my @items = @{ $item };
    my $name = shift @items;
    $name = "_$name";
    $self->$name(@items);
}

sub stack_walker {
    my($self, $items) = @_;
    my @results;
    for my $data (@{ $items }) {
        push @results, $self->walk($data->{data});
    }
    @results;
}

sub _stack_walker_with_merge {
    join '', $_[0]->stack_walker($_[1]);
}

sub _paragraph { shift->_stack_walker_with_merge(@_) }

sub _line {}

sub _body { shift->_stack_walker_with_merge(@_) }
sub _sections { shift->_stack_walker_with_merge(@_) }

sub _section1 {
    my($self, $head, $items) = @_;
    join '', $self->walk($head->{data}), $self->stack_walker($items);
}
sub _content1 { shift->_stack_walker_with_merge(@_) }
sub _section2 { shift->_section1(@_) }
sub _content2 { shift->_content1(@_) }
sub _section3 { shift->_section1(@_) }
sub _content3 { shift->_content1(@_) }
sub _column_section { shift->_section1(@_) }
sub _column_content { shift->_content1(@_) }

sub _head_base {}
sub _head1 { shift->_head_base('H1', @_) }
sub _head2 { shift->_head_base('H2', @_) }
sub _head3 { shift->_head_base('H3', @_) }
sub _column_head { shift->_head_base('H1', @_) }

sub _list {}
sub _list_body { shift->_chars(@_) }

sub _ul {}
sub _li {}

sub _phrase { shift->_stack_walker_with_merge(@_) }

sub _semi_phrase {
    my($self, $items, $suffix) = @_;
    join '', $self->stack_walker($items), $suffix;
}

sub _tag_phrase {
    my($self, $prefix, $items) = @_;
    my @htmls;
    push @htmls, $self->stack_walker($prefix);
    push @htmls, $self->walk($items->{data});
    join '', @htmls;
}

sub _tags {
    my($self, $items) = @_;
    join '', $self->walk($items->{data});
}

sub _tag_body {}
sub _tag_ruby {}
sub _tag_caption {}

sub _tag_body_chars {
    my($self, $rhombus, $items) = @_;
    join '', $rhombus, $self->stack_walker($items);
}

sub _tag_body_chars_base { shift->_chars(@_) }

sub _tag_body_phrase { shift->_stack_walker_with_merge(@_) }

sub _chars {}

1;

