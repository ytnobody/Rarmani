package Rarmani::Driver;
use Moo;
use namespace::clean;
use Types::Common -types;
use Class::Load ();

has driver_type => (is => 'ro', isa => Str, required => 1);

around new => sub {
    my ($orig, $class, %params) = @_;
    my $self = $class->$orig(%params);
    my $driver_class = 'Rarmani::Driver::'. $self->driver_type;
    Class::Load::load_class($driver_class);
    return $self;
};

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