#!perl

use strict;
use warnings;

use App::Genpass;
use Test::More tests => 1001;

my $app    = App::Genpass->new( minlength => 7, maxlength => 10 );
my $pass   = $app->generate(); # default is to generate 1
my %seen;

for (my $i=0; $i<1000; $i++) {
    $pass = $app->generate();
    ok(defined($pass) && length($pass) >= 7 && length($pass) <= 10);
    $seen{ length($pass) } = 1;
}

ok($seen{7} && $seen{8} && $seen{9} && $seen{10}, "seen all expected password lengths");

