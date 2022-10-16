package Rarmani::Driver;
use Moo;
use namespace::clean;
use Types::Common -types;
use Rarmani::Driver::MySQL;
use Rarmani::Driver::SQLite;
use Rarmani::Driver::Pg;

has driver_type => (is => 'ro', isa => Str, required => 1);

sub driver_class {
    my ($self, $coldata) = @_;
    return __PACKAGE__. '::'. $self->driver_type;
}

sub build_column {
    my ($self, $coldata) = @_;
    return $self->driver_class->build_column_params(%$coldata);
}

sub column_definition_rule {
    my ($self, $coldata) = @_;
    return $self->driver_class->column_definition_rule;
}

1;