use strict;
use Test::More;
use Test::Deep;

use_ok 'Rarmani::Parser';

my $parser = Rarmani::Parser->new(driver => 'Pg');
isa_ok $parser, 'Rarmani::Parser';

my $sql = do {local $/; <DATA>};
my @tables = $parser->parse($sql);

for my $table (@tables) {
    isa_ok $table, 'Rarmani::Table';
}
is join(' ', map {$_->name} @tables), 'accounts orders product_tags';

my ($accounts, $orders, $product_tags) = @tables;

my @columns;

isa_ok $accounts->columns, 'ARRAY';
@columns = @{$accounts->columns};
is scalar(@columns), 6;
for my $column (@columns) {
    isa_ok $column, 'Rarmani::Column';
}
is join(' ', map {$_->name} @columns), 'user_id username password email created_on last_login';
is join(' ', map {$_->datatype->name} @columns), 'Int StrLength StrLength StrLength DateTime DateTime';
is join(' ', map {$_->not_null} @columns), '0 1 1 1 1 0';
is join(' ', map {$_->length} @columns), '0 50 50 255 0 0';

done_testing;

__DATA__
CREATE TABLE accounts (
	user_id serial PRIMARY KEY,
	username VARCHAR (50) UNIQUE NOT NULL,
	password VARCHAR (50) NOT NULL,
	email VARCHAR (255) UNIQUE NOT NULL,
	created_on TIMESTAMP NOT NULL,
  last_login TIMESTAMP
);

CREATE TABLE orders ( 
  order_id integer NOT NULL,
  order_date date,
  quantity integer,
  notes varchar(200),
  CONSTRAINT orders_pk PRIMARY KEY (order_id)
);

CREATE TABLE product_tags ( 
  product_id INTEGER NOT NULL,
  tag_id SERIAL NOT NULL,
  production_date VARCHAR(20),
  tag_peni VARCHAR(20),
  item_number VARCHAR(20),
  PRIMARY KEY(product_id, tag_id)
);