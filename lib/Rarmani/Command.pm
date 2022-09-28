package Rarmani::Command;
use Moo;
use MooX::Options;
use Rarmani;

option driver => (
    is       => 'ro', 
    format   => 's', 
    required => 1,
    doc      => 'Driver name (ex. MySQL)',
);

option namespace => (
    is       => 'ro', 
    format   => 's', 
    required => 1,
    doc      => 'Namespace prefix of Schema class that be generated',
);

option path => (
    is       => 'ro', 
    format   => 's', 
    required => 0, 
    default  => '.',
    doc      => 'Destination path of Schema class that be generated',
);

option roles => (
    is       => 'ro', 
    format   => 's@', 
    required => 0, 
    default  => sub { [] },
    doc      => 'Roles that be applied to schema class',
);

sub generate {
    my ($self) = @_;
    my $r = Rarmani->new(
        driver    => $self->driver,
        namespace => $self->namespace,
        path      => $self->path,
        roles     => $self->roles,
    );
    my $sql = do {local $/; <STDIN>};
    $r->generate_schema_classes($sql);
}

1;