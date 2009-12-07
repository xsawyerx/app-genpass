#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'App::Genpass' );
}

diag( "Testing App::Genpass $App::Genpass::VERSION, Perl $], $^X" );
