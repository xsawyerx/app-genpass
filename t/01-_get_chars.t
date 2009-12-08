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
);

my $chars = $app->_get_chars();
cmp_bag( $chars, [ qw( a A 1 ! o ) ], 'got all chars we wanted' );

$app = App::Genpass->new(
    lowercase  => ['a'],
    uppercase  => ['A'],
    numerical  => [ 1 ],
    unreadable => ['o'],
    specials   => [   ],
);

$chars = $app->_get_chars();
cmp_bag( $chars, [ qw( a A 1 o ) ], 'can set empty chars' );
