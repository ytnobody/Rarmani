package Rarmani;
use 5.008001;
use strict;
use warnings;
use Moo;
use namespace::clean;
use Types::Standard -types;
use Rarmani::Parser;
use Rarmani::Generator;

our $VERSION = "0.01";

has driver    => (is => 'ro', isa => Str, required => 1);
has parser    => (is => 'ro', isa => InstanceOf['Rarmani::Parser'], default => sub { Rarmani::Parser->new });
has namespace => (is => 'rw', isa => Str, default => 'MyApp::Schema');
has path      => (is => 'rw', isa => Str, default => '.');

sub generate_schema_classes {
    my ($self, $sql) = @_;
    my @tables = $self->parser->parse($sql, $self->namespace);
    my $gen    = Rarmani::Generator->new(tables => [@tables], namespace => $self->namespace, path => $self->path);
    $gen->generate_schemas();
}

1;
__END__

=encoding utf-8

=head1 NAME

Rarmani - Generates data schema classes that uses Moo (However incomplete)

=head1 SYNOPSIS

    use Rarmani;
    my $r = Rarmani->new(driver => 'mysql', schema_class => 'MyApp::Schema');
    $r->generate_from_sql($sql_string);
    __DATA__
    CREATE TABLE 'books' (
        `id`       INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
        `name`     VARCHAR(250) NOT NULL,
        `author`   TEXT NOT NULL,
        `added_at` DATETIME NOT NULL
    );

=head1 DESCRIPTION

Rarmani is a magical "Japanese yew" for generate schema class that using Moo from SQL.

=head1 LICENSE

Copyright (C) ytnobody.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

ytnobody E<lt>ytnobody@gmail.comE<gt>

=cut

