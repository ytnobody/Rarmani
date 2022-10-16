use strict;
use warnings;
use Test::More;
use Test::Exception;
use Rarmani;
use DateTime;

my $sql = do {local $/; <DATA>};

my $r = Rarmani->new(driver => 'Pg', namespace => 'MyCoolApp::Schema', roles => [qw[Moo::Role::ToJSON]]);
$r->generate_schema_classes($sql);

ok -f 'MyCoolApp/Schema/Orders.pm';

use lib '.';
use_ok 'MyCoolApp::Schema::Orders';

my $order = MyCoolApp::Schema::Orders->new();
can_ok $order, qw/order_id order_date quantity notes TO_JSON/;
lives_ok  { $order->order_id(100) };
throws_ok { $order->order_id('postgresql') } qr/did not pass type constraint/;
throws_ok { $order->order_id('') } qr/did not pass type constraint/;
lives_ok  { $order->order_date('2022-09-10') };
throws_ok { $order->order_date('2022/09/10') } qr/did not pass type constraint/;
my $now = DateTime->now;
lives_ok  { $order->order_date($now) };
lives_ok  { $order->quantity(20) };
throws_ok { $order->quantity('hoge@example.com') } qr/did not pass type constraint/;
throws_ok { $order->quantity('') } qr/did not pass type constraint/;
lives_ok  { $order->notes('postgresql') };
throws_ok { $order->notes('postgresql' x 22) } qr/did not pass type constraint/;
lives_ok  { $order->notes('') };

done_testing;

__DATA__
CREATE TABLE orders ( 
  order_id integer NOT NULL,
  order_date date,
  quantity integer,
  notes varchar(200),
  CONSTRAINT orders_pk PRIMARY KEY (order_id)
);

