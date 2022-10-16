use strict;
use warnings;
use Test::More;
use Test::Exception;
use Rarmani;
use DateTime;

my $sql = do {local $/; <DATA>};

my $r = Rarmani->new(driver => 'MySQL', namespace => 'MyCoolApp::Schema', roles => [qw[Moo::Role::ToJSON]]);
$r->generate_schema_classes($sql);

ok -f 'MyCoolApp/Schema/AdminAccount.pm';

use lib '.';
use_ok 'MyCoolApp::Schema::AdminAccount';

my $admin1 = MyCoolApp::Schema::AdminAccount->new();
can_ok $admin1, qw/id email name note created_at updated_at TO_JSON/;
lives_ok  { $admin1->id('admin001001') };
throws_ok { $admin1->id('admin001001' x 5) } qr/did not pass type constraint/;
lives_ok  { $admin1->id('') };
lives_ok  { $admin1->email('hoge@example.com') };
throws_ok { $admin1->email('hoge@example.com' x 20) } qr/did not pass type constraint/;
lives_ok  { $admin1->email('') };
lives_ok  { $admin1->name('admin001001') };
throws_ok { $admin1->name('admin001001' x 20) } qr/did not pass type constraint/;
lives_ok  { $admin1->name('') };
lives_ok  { $admin1->note('admin001001') };
lives_ok  { $admin1->note('admin001001' x 20) };
lives_ok  { $admin1->note('') };
lives_ok  { $admin1->created_at('2022-09-10 01:22:33') };
lives_ok  { $admin1->created_at('2022/09/10 01:22:33') };
throws_ok { $admin1->created_at('2022-09-10T01:22:33Z') } qr/did not pass type constraint/;
my $now = DateTime->now;
lives_ok  { $admin1->created_at($now) };

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

