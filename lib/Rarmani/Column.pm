package Rarmani::Column;
use Moo;
use namespace::clean;
use Types::Common -types;
use Text::Xslate;

has driver      => (is => 'ro', isa => Str, required => 1);
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
has <: $self.name() :> => (
    is  => 'rw',
    isa => <: $self.as_column_type() | raw :>,
: if $self.datatype().name() == "DateTime" {
    coerce => 1,
: }
);

EOS
    my $tx = Text::Xslate->new(syntax => 'Kolon');
    return $tx->render_string($tmpl, { self => $self });
    return sprintf($tmpl, $self->name, $self->as_column_type);
}

sub as_column_type {
    my ($self) = @_;
    return sprintf("%s[0,%d] | Undef", $self->datatype->name, $self->length) if $self->length > 0;
    return sprintf("%s->plus_coercions(Format['%s']) | Undef", $self->datatype->name, $self->driver) if $self->datatype->name eq 'DateTime';
    return sprintf("%s | Undef", $self->datatype->name);
}

1;