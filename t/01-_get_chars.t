#!perl

use strict;
use warnings;

use App::Genpass;
use Test::More tests => 4;
use Test::Deep 'cmp_bag';

my %default_opts = (
    lowercase  => ['a'],
    uppercase  => ['A'],
    numerical  => [ 1 ],
    unreadable => ['o'],
);

my %options = (
    'testing all with readable flag' => {
        specials => ['!'],
        readable => 1,
        result   => [ qw( a A 1 ! ) ],
    },

    'testing all without readable flag' => {
        specials => ['!'],
        readable => 0,
        result   => [ qw( a A 1 ! o ) ],
    },

    'testing all with one removed with readable flag' => {
        specials => [],
        readable => 1,
        result   => [ qw( a A 1 ) ],
    },

    'testing all with one removed without readable flag' => {
        specials => [],
        readable => 0,
        result   => [ qw( a A 1 o ) ],
    },
);

while ( my ( $opt_name, $opt_data ) = ( each %options ) ) {
    my $res = delete $opt_data->{'result'};
    #use Data::Dumper; print Dumper $opt_data;
    my $app = App::Genpass->new(
        %{$opt_data},
        %default_opts,
    );

    my $chars = $app->_get_chars();
    cmp_bag( $chars, $res, $opt_name );
}

