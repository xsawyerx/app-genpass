#!perl

use strict;
use warnings;

use App::Genpass;
use Test::More tests => 2;
use Test::Deep 'cmp_bag';

my $app = App::Genpass->new(
    lowercase  => ['a'],
    uppercase  => ['A'],
    numerical  => [ 1 ],
    unreadable => ['o'],
    specials   => ['!'],
    readable   => 0,
);

my $chars = $app->_get_chars();
cmp_bag( $chars, [ qw( a A 1 ! o ) ], 'got all chars we wanted' );

$app = App::Genpass->new(
    lowercase  => ['a'],
    uppercase  => ['A'],
    numerical  => [ 1 ],
    unreadable => ['o'],
    specials   => [   ],
    readable   => 0,
);

$chars = $app->_get_chars();
cmp_bag( $chars, [ qw( a A 1 o ) ], 'can set empty chars' );
