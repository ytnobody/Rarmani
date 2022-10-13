package Rarmani::Table;
use Moo;
use namespace::clean;
use Types::Common -types;

has driver      => (is => 'ro', isa => Str, required => 1);
has name        => (is => 'ro', isa => Str, required => 1);
has columns     => (is => 'ro', isa => ArrayRef[InstanceOf['Rarmani::Column']]);
has primary_key => (is => 'ro', isa => ArrayRef[Str], required => 0, default => sub { [] });
has roles     => (is => 'rw', isa => ArrayRef[Str], default => sub { [] });

1;
