package Rarmani::Driver::SQLite;
use strict;
use warnings;
use Types::Common -types;
use Types::DateTime -all;

our @TypesMatcher = (
    { type => Int, regex => qr/^(INTEGER)$/ },
    { type => Num, regex => qr/^(NUMERIC)$/ },
    { type => Bool, regex => qr/^(BOOL)$/ },
    { type => Str, regex => qr/^(TEXT|REAL)$/ },
    { type => DateTime, regex => qr/^(DATETIME)$/ },
    { type => Any, regex => qr/^.*$/ },    
);

sub column_definition_rule {
    return qr/(?<name>`?[\w_]+`?) *(?<datatype>\w+)? *(?<options>[\w_\'\(\), ]+)? *,?/is;
}

sub build_column_params {
    my ($class, %params) = @_;
    my $res_params;
    for my $matcher (@TypesMatcher) {
        $res_params = $class->build_column_param($matcher, %params);
        return %$res_params if $res_params; 
    }
    return;
}

sub build_column_param {
    my ($class, $matcher, %params) = @_;
    my $type     = $matcher->{type};
    my $regex    = $matcher->{regex};
    my $name     = $params{name};
    my $datatype = $params{datatype} || "";
    my $options  = $params{options};
    
    my $res_params;

    if (my ($typename, $length) = $datatype =~ $regex) {
        my $res_params = {
            datatype => $type, 
            name     => $name, 
            options  => $options,
            raw_type => $typename,
            length   => 0,
            not_null => 0,
        };
        $res_params = $class->resolve_options(%$res_params);
        return $res_params;
    }
}

sub resolve_options {
    my ($class, %params) = @_;
    if (defined $params{options} && $params{options} =~ /NOT NULL/) {
        $params{not_null} = 1;
    }
    return {%params};
}
