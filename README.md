# NAME

Rarmani - Generates data schema classes that uses Moo (However incomplete)

# SYNOPSIS

in your generator script...

    use Rarmani;
    my $r   = Rarmani->new(driver => 'MySQL', schema_class => 'MyApp::Schema');
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

or you can use \`rarmani\` command instead.

    rarmani --driver=MySQL --namespace=Charon::Schema --path=./myapp/lib/ < ./path/to/create_tables.sql

# DESCRIPTION

Rarmani is a magical "Japanese yew" for generate schema class that using Moo from SQL.

# LICENSE

Copyright (C) ytnobody.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

ytnobody <ytnobody@gmail.com>
