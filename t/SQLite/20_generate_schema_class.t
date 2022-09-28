use strict;
use warnings;
use Test::More;
use Test::Exception;
use Rarmani;
use DateTime;

my $sql = do {local $/; <DATA>};

my $r = Rarmani->new(driver => 'SQLite', namespace => 'MyCoolApp::Schema', roles => [qw[Moo::Role::ToJSON]]);
$r->generate_schema_classes($sql);

ok -f 'MyCoolApp/Schema/AdminAccount.pm';

use lib '.';
use_ok 'MyCoolApp::Schema::AdminAccount';

my $admin1 = MyCoolApp::Schema::AdminAccount->new();
can_ok $admin1, qw/id email name note created_at updated_at TO_JSON/;
lives_ok  { $admin1->id('admin001001') };
lives_ok { $admin1->id('admin001001' x 5) };
lives_ok { $admin1->id('') };
lives_ok  { $admin1->email('hoge@example.com') };
lives_ok { $admin1->email('hoge@example.com' x 20) };
lives_ok { $admin1->email('') };
lives_ok  { $admin1->name('admin001001') };
lives_ok { $admin1->name('admin001001' x 20) };
lives_ok { $admin1->name('') };
lives_ok  { $admin1->note('admin001001') };
lives_ok  { $admin1->note('admin001001' x 20) };
lives_ok  { $admin1->note('') };
lives_ok  { $admin1->created_at('2022-09-10 01:22:33') };
throws_ok  { $admin1->created_at('2022/09/10 01:22:33') } qr/did not pass type constraint/;
throws_ok { $admin1->created_at('2022-09-10T01:22:33Z') } qr/did not pass type constraint/;
my $now = DateTime->now;
lives_ok  { $admin1->created_at($now) };

done_testing;

__DATA__
CREATE TABLE `admin_account` (
  `id` text,
  `email` text,
  `name` text,
  `note` text,
  `created_at` datetime,
  `updated_at` datetime
);