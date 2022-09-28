package Rarmani;
use Moo;
use namespace::clean;
use Types::Standard -types;
use Rarmani::Parser;
use Rarmani::Generator;

our $VERSION = "0.01";

has driver    => (is => 'ro', isa => Str, required => 1);
has parser    => (is => 'rw', isa => InstanceOf['Rarmani::Parser']);
has namespace => (is => 'rw', isa => Str, default => 'MyApp::Schema');
has path      => (is => 'rw', isa => Str, default => '.');
has roles     => (is => 'rw', isa => ArrayRef[Str], default => sub { [] });

around new => sub {
    my ($orig, $class, %params) = @_;
    $params{parser} ||= Rarmani::Parser->new(driver => $params{driver});
    return $class->$orig(%params);
};

sub generate_schema_classes {
    my ($self, $sql) = @_;
    $self->parser->roles($self->roles);
    my @tables = $self->parser->parse($sql, $self->namespace);
    my $gen    = Rarmani::Generator->new(
        tables    => [@tables], 
        namespace => $self->namespace, 
        path      => $self->path, 
        driver    => $self->driver,
        roles     => $self->roles,
    );
    $gen->generate_schemas();
}

1;
__END__

=encoding utf-8

=head1 NAME

Rarmani - Generates data schema classes that uses Moo (However incomplete)

=head1 SYNOPSIS

in your generator script...

    use Rarmani;
    my $r   = Rarmani->new(driver => 'MySQL', schema_class => 'MyApp::Schema', roles => [qw[Moo::Role::ToJSON MyApp::Roles::SomeOne]]);
    my $sql = do {local $/; <DATA>};
    $r->generate_from_sql($sql);
    __DATA__
    CREATE TABLE 'books' (
        `id`       INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
        `name`     VARCHAR(250) NOT NULL,
        `author`   TEXT NOT NULL,
        `added_at` DATETIME NOT NULL
    );

and you can use generated schemas as followings.

    use MyApp::Schema::Books;
    use DateTime;
    my $book = MyApp::Schema::Books->new(
        id       => 10, 
        name     => 'Perl Hacks', 
        author   => 'chromatic, Damian Conway, Curtis "Ovid" Poe',
        added_at => DateTime->now,
    );

or you can use `rarmani` command instead.

    rarmani --driver=MySQL --namespace=YourApp::Schema --path=./myapp/lib/ < ./path/to/create_tables.sql

=head1 DESCRIPTION

Rarmani is a magical "Japanese yew" for generate schema class that using Moo from SQL.

=head1 LICENSE

Copyright (C) ytnobody.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

ytnobody E<lt>ytnobody@gmail.comE<gt>

=cut

