package Rarmani::Driver::MySQL;
use Moo;
use namespace::clean;
use Types::Standard -types;
use Types::Common::String -types;
use Types::DateTime -all;

our @TypesMatcher = (
    { type => Int,           regex => qr/^(INTEGER|INT|SMALLINT|TINYINT|MEDIUMINT|BIGINT)([\(\)0-9]+)?$/ },
    { type => Num,           regex => qr/^(DECIMAL|NUMERIC|FLOAT|DOUBLE)([\(\)0-9]+)?/ },
    { type => Str,           regex => qr/^(BINARY|VARBINARY|BLOB|TEXT)/ },
    { type => StrLength      regex => qr/^(BIT|CHAR|VARCHAR)([\(\)0-9]+)?/ },
    { type => DateTime,      regex => qr/^(DATE|DATETIME|TIMESTAMP|YEAR)/ },
    { type => Enum,          regex => qr/^(ENUM([\(\).+]+)$)/ },
    { type => ArrayRef[Str], regex => qr/^(SET([\(\).+]+))/ },
);

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
    my $datatype = $params{datatype};
    my $options  = $params{options};
    
    if (my ($typename, $length) = $datatype =~ $regex) {
        $length =~ s/[\(\)]//g if defined $length;
        $length //= 0;
        my $res_params = {
            datatype => $type, 
            name     => $name, 
            options  => $options,
            raw_type => $typename,
            length   => 0+ $length,
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
