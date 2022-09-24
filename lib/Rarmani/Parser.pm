package Rarmani::Parser;
use Moo;
use namespace::clean;
use Types::Standard -types;
use Rarmani::Table;
use Rarmani::Driver;
use Rarmani::Column;

has driver => (is => 'rw', isa => Str, default => "MySQL");

sub parse {
    my ($self, $sql) = @_;
    $sql =~ s/^[-;]{2}.*$//g;
    my @stmt_list = split(/;\n/, $sql);
    my @tables = grep { defined $_ } map { $self->_parse_create_stmt($_) } @stmt_list;
    return @tables;
}

sub _parse_create_stmt {
    my ($self, $sql) = @_;
    my $stmt_hash = $self->_find_create_stmt($sql);
    return Rarmani::Table->new(%$stmt_hash) if $stmt_hash;
}

sub _find_create_stmt {
    my ($self, $sql) = @_;
    my ($table_name, $stmt) = $sql =~ m/CREATE +(?:[\w_]* +?)?TABLE +(["`\w\._]+) *\((.+)\)/is;
    return unless $table_name;
    $table_name =~ s/[\"`]//g;
    my @columns = $self->_find_column_definition($stmt);
    return {
        name    => $table_name,
        columns => [@columns],
        driver  => $self->driver,
    };
}

sub _find_column_definition {
    my ($self, $sql) = @_;
    my $match = +{};
    my @columns = ();
    my $column;
    my $pattern = qr/(?<name>[`\w_]+) +(?<datatype>[\w\)\(0-9]+) *(?<options>[\w_ ]+)? *,?/is;
    my $driver = Rarmani::Driver->new(driver_type => $self->driver);
    while ( $sql =~ $pattern ) {
        $match = +{%+};
        $match->{name} =~ s/[\"`]//g;
        $match->{datatype} = uc($match->{datatype});
        $match->{options} = uc($match->{options}) if $match->{options};
        if (my %column_params = $driver->build_column($match)) {
            $column = Rarmani::Column->new(%column_params, driver => $self->driver);
            push @columns, $column;
        }
        $sql =~ s/$pattern//;
    }
    return @columns;
}
1;