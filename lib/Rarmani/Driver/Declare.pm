package Rarmani::Driver::Declare;

use Exporter 'import';
use Carp ();

our @EXPORT = qw(build_column_params column_definition_rule type_match column_match skip_name);

my @TypesMatcher = ();
my $ColumnDefinitionRule = qr/^ +(?<name>`?[\w_]+`?) *(?<datatype>[\w\)\(0-9]+)? *(?<options>[\w_ ]+)? *,?/ims;
my @SkipNames = qw(PRIMARY UNIQUE INDEX CONSTRAINT);

sub type_match ($$) {
    my ($type, $regex) = @_;
    Carp::croak("type_match wants type specifier") unless $type;
    Carp::croak("type_match wants regex specifier") unless $regex;
    @TypesMatcher = grep {$_->{type} ne $type} @TypesMatcher;
    push @TypesMatcher, {type => $type, regex => $regex};
}

sub column_match ($) {
    my ($rule) = @_;
    $ColumnDefinitionRule = $rule;
}

sub skip_name ($) {
    my ($name) = @_;
    push @SkipNames, $name;
}

sub column_definition_rule {
    return $ColumnDefinitionRule;
}

sub build_column_params {
    my ($class, %params) = @_;
    my $res_params;
    for my $matcher (@TypesMatcher) {
        $res_params = __PACKAGE__->_build_column_param($matcher, %params);
        return %$res_params if $res_params; 
    }
    return;
}

sub _build_column_param {
    my ($class, $matcher, %params) = @_;
    my $type     = $matcher->{type};
    my $regex    = $matcher->{regex};
    my $name     = $params{name};
    my $datatype = $params{datatype} || "";
    my $options  = $params{options};

    my $skip_rule = sprintf('^(%s)$', join("|", @SkipNames));
    return if $name =~ qr/$skip_rule/;
    
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
        $res_params = __PACKAGE__->_resolve_options(%$res_params);
        return $res_params;
    }
}

sub _resolve_options {
    my ($class, %params) = @_;
    if (defined $params{options} && $params{options} =~ /NOT NULL/) {
        $params{not_null} = 1;
    }
    return {%params};
}

1;