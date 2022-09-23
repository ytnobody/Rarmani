package Rarmani::Driver;
use Moo;
use namespace::clean;
use Types::Standard -types;
use Rarmani::Driver::mysql;

has driver_type => (is => 'ro', isa => Str, default => 'mysql');

sub build_column {
    my ($self, $coldata) = @_;
    my $driver_class = __PACKAGE__. '::'. $self->driver_type;
    return $driver_class->build_column_params(%$coldata);
}

1;