package Rarmani::Column;
use Moo;
use namespace::clean;
use Types::Standard -types;
use Types::Common::Numeric -types;

has name        => (is => 'ro', isa => Str, required => 1);
has datatype    => (is => 'ro', isa => InstanceOf['Type::Tiny'], required => 1);
has foreign_key => (is => 'ro', isa => Str | Undef, required => 0, default => undef);
has options     => (is => 'ro', isa => Str | Undef, required => 0, default => undef);
has raw_type    => (is => 'ro', isa => Str, required => 1);
has length      => (is => 'ro', isa => PositiveOrZeroInt | Undef, required => 0, default => undef);
has not_null    => (is => 'ro', isa => Bool, required => 1, default => 0);

sub as_hashref {
    my ($self) = @_;
    return {
        name     => $self->name,
        datatype => $self->datatype->name, 
        options  => $self->options,
        raw_type => $self->raw_type,
        length   => $self->length,
        not_null => $self->not_null,
    };
}

sub as_definition {
    my ($self) = @_;
    my $tmpl = <<'EOS';
has %s => (
    is  => 'rw',
    isa => %s,
);

EOS
    return sprintf($tmpl, $self->name, $self->as_column_type);
}

sub as_column_type {
    my ($self) = @_;
    return sprintf("%s[1,%d] | Undef", $self->datatype->name, $self->length) if $self->length > 0;
    return sprintf("%s | Undef", $self->datatype->name);
}

1;