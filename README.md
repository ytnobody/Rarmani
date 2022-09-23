# NAME

Rarmani - Generates data schema classes that uses Moo (However incomplete)

# SYNOPSIS

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

# DESCRIPTION

Rarmani is a magical "Japanese yew" for generate schema class that using Moo from SQL.

# LICENSE

Copyright (C) ytnobody.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

ytnobody <ytnobody@gmail.com>
