use strict;
use Test::More;
use Test::Deep;

use_ok 'Rarmani::Parser';

my $parser = Rarmani::Parser->new(driver => 'MySQL');
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
is join(' ', map {$_->datatype->name} @columns), 'StrLength StrLength StrLength Str DateTime DateTime';
is join(' ', map {$_->not_null} @columns), '1 1 1 0 1 0';
is join(' ', map {$_->length} @columns), '40 255 120 0 0 0';

done_testing;

__DATA__
DROP TABLE IF EXISTS `admin_account`;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `admin_account` (
  `id` char(40) NOT NULL,
  `email` varchar(255) NOT NULL,
  `name` varchar(120) NOT NULL,
  `note` text,
  `created_at` datetime NOT NULL,
  `updated_at` datetime,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx1` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `user_account`;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `user_account` (
  `id` char(40) NOT NULL,
  `email` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx1` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `book`;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `book` (
  `id` char(40) NOT NULL,
  `title` varchar(255) NOT NULL,
  `author` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx1` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
