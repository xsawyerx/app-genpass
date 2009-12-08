#!perl

use strict;
use warnings;

use App::Genpass;
use Test::More tests => 1;
use Test::Deep 'cmp_bag';

my $app = App::Genpass->new(
    lowercase => ['a'],
    uppercase => ['A'],
    numerical => [ 1 ],
    specials  => ['!'],
);

my @chars = split //, $app->_get_chars();
cmp_bag( \@chars, [ qw( a A 1 ! ) ], 'got all chars we wanted' );
