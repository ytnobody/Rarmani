use strict;
use Test::More;
use Test::Deep;

use_ok 'Rarmani::Parser';

my $parser = Rarmani::Parser->new(driver => 'SQLite');
isa_ok $parser, 'Rarmani::Parser';

my $sql = do {local $/; <DATA>};
my @tables = $parser->parse($sql);

for my $table (@tables) {
    isa_ok $table, 'Rarmani::Table';
}
is join(' ', map {$_->name} @tables), 'admin_account user_account book';

my ($admin_account, $user_account, $book) = @tables;

my @columns;

isa_ok $admin_account->columns, 'ARRAY';
@columns = @{$admin_account->columns};
is scalar(@columns), 6;
for my $column (@columns) {
    isa_ok $column, 'Rarmani::Column';
}
is join(' ', map {$_->name} @columns), 'id email name note created_at updated_at';
is join(' ', map {$_->datatype->name} @columns), 'Any Any Any Any Any Any';

isa_ok $user_account->columns, 'ARRAY';
@columns = @{$user_account->columns};
is scalar(@columns), 4;
for my $column (@columns) {
    isa_ok $column, 'Rarmani::Column';
}
is join(' ', map {$_->name} @columns), 'id email created_at updated_at';
is join(' ', map {$_->datatype->name} @columns), 'Str Str Int Int';

done_testing;

__DATA__
CREATE TABLE admin_account (
  id,
  email, 
  name, 
  note, 
  created_at, 
  updated_at
);

CREATE TABLE user_account (
  id         TEXT,
  email      TEXT,
  created_at INTEGER,
  updated_at INTEGER
);

CREATE TABLE book (
  id,
  title,
  author,
  created_at,
  updated_at
);
