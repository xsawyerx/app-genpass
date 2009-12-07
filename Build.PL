use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'App::Genpass',
    license             => 'perl',
    dist_author         => q{Sawyer X <xsawyerx@cpan.org>},
    dist_version_from   => 'lib/App/Genpass.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'App-Genpass-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
