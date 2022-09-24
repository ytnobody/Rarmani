requires 'perl', '5.008001';
requires 'namespace::clean', '0.27';
requires 'Moo', '2.005004';
requires 'Types::Standard', '1.016008';
requires 'Types::DateTime', '0.0002';
requires 'DateTime::Format::MySQL', '0.0701';
requires 'Text::Xslate', 'v3.5.9';
requires 'String::CamelCase', '0.04';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

