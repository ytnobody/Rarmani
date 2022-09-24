package Rarmani::Generator;
use Moo;
use namespace::clean;
use Types::Standard -types;
use Text::Xslate;
use String::CamelCase ();
use File::Spec ();
use File::Path ();
use Carp ();
use Term::ANSIColor;

our $TEMPLATE = do {local $/; <DATA>};

has driver    => (is => 'ro', isa => Str, required => 1);
has tables    => (is => 'rw', isa => ArrayRef[InstanceOf['Rarmani::Table']]);
has namespace => (is => 'rw', isa => Str, required => 1);
has path      => (is => 'rw', isa => Str, default => '.');
has roles     => (is => 'rw', isa => ArrayRef[Str], default => sub { [] });

sub generate_schemas {
    my ($self) = @_;
    for my $table (@{$self->tables}) {
        $self->generate_schema_class($table);
    }
}

sub generate_schema_class {
    my ($self, $table) = @_;
    my $dir    = $self->schema_class_dir($table, $self->namespace, $self->path);
    my $file   = $self->schema_class_file_name($table, $self->namespace, $self->path);
    my $path   = $self->schema_class_file_path($table, $self->namespace, $self->path);
    my $source = $self->table_as_schema_class($table, $self->namespace);
    File::Path::mkpath($dir);
    open my $fh, '>', $path or Carp::croak($!);
    print $fh $source;
    close $fh;
    my $cyan   = color('cyan');
    my $green  = color('green');
    my $yellow = color('yellow');
    my $reset  = color('reset');
    printf($cyan."[generate]".$reset." ".$green."%s".$reset." --> ".$yellow."%s".$reset."\n", $self->schema_class_name($table, $self->namespace), $path);
}

sub table_as_schema_class {
    my ($self, $table, $namespace) = @_;
    my $class_name = $self->schema_class_name($table, $namespace);
    my $has_datetime = 0;
    my $has_strlength = 0;
    for my $column (@{$table->columns}) {
        my $datatype = $column->datatype->name;
        if ($datatype eq 'DateTime') {
            $has_datetime = 1;
            last;
        } elsif ($datatype =~ /^StrLength/) {
            $has_strlength = 1;
        }
    }
    my @roles = @{$self->roles};
    my $params = {
        table         => $table->name,
        class_name    => $class_name,
        has_datetime  => $has_datetime,
        has_strlength => $has_strlength,
        columns       => $table->columns,
        driver        => $self->driver,
        roles         => scalar(@roles) > 0 ? join(' ', @roles) : "",
    };

    my $tx = Text::Xslate->new(syntax => 'Kolon');
    return $tx->render_string($TEMPLATE, $params);
}

sub schema_class_name {
    my ($self, $table, $namespace) = @_;
    return $namespace. '::'. String::CamelCase::camelize($table->name);
}

sub schema_class_dir {
    my ($self, $table, $namespace, $base_path) = @_;
    my @parts = split(/::/, $self->schema_class_name($table, $namespace));
    pop @parts;
    return File::Spec->catdir($base_path, @parts);
}

sub schema_class_file_name {
    my ($self, $table, $namespace, $base_path) = @_;
    my @parts = split(/::/, $self->schema_class_name($table, $namespace));
    return $parts[$#parts] . '.pm';
}

sub schema_class_file_path {
    my ($self, $table, $namespace, $base_path) = @_;
    my $dir  = $self->schema_class_dir($table, $namespace, $base_path);
    my $file = $self->schema_class_file_name($table, $namespace, $base_path);
    return File::Spec->catfile($dir, $file);
}

1;

__DATA__
package <: $class_name :>;
use Moo;
: if ($roles) {
with qw/<: $roles :>/;
: }
use namespace::clean;
use Types::Standard -types;
: if ($has_datetime) {
use Types::DateTime -all;
use DateTime::Format::<: $driver :>;
: }
: if ($has_strlength) {
use Types::Common::String -types;
: }

our $TABLE = '<: $table :>';

: for $columns -> $column {
:   $column.as_definition() | raw
: }
"Generated by Rarmani::Generator";