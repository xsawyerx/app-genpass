#!perl

use strict;
use warnings;

use App::Genpass;
use Test::More tests => 12;
use List::MoreUtils qw( any none );

my %opts = (
    lowercase  => ['a'],
    uppercase  => ['A'],
    numerical  => [ 1 ],
    unreadable => ['o'],
    specials   => ['!'],
);

my $length = 30;
my $app    = App::Genpass->new( %opts, readable => 0, length => $length );
my $pass   = $app->generate(); # default is to generate 1

cmp_ok( length $pass, '==', $length, 'correct length' );
foreach my $arrayref ( values %opts ) {
    my $val = $arrayref->[0];
    ok(
        ( any { $val eq $_ } ( split //, $pass ) ),
        "got $val in generated pass",
    );
}

# delete readable
$app  = App::Genpass->new( %opts, readable => 1, length => $length );
$pass = $app->generate();

my $special    = shift @{ delete $opts{'specials'}   };
my $unreadable = shift @{ delete $opts{'unreadable'} };

cmp_ok( length $pass, '==', $length, 'correct length' );
foreach my $arrayref ( values %opts ) {
    my $val = $arrayref->[0];
    ok(
        ( any { $val eq $_ } ( split //, $pass ) ),
        "got $val in generated pass",
    );
}

ok(
    ( none { $special    eq $_ } ( split //, $pass ) ),
    "missing $special",
);

ok(
    ( none { $unreadable eq $_ } ( split //, $pass ) ),
    "missing $unreadable",
);

