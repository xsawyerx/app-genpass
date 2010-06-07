use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'App::Genpass',
    license             => 'perl',
    dist_author         => q{Sawyer X <xsawyerx@cpan.org>},
    dist_version_from   => 'lib/App/Genpass.pm',
    build_requires => {
        'Test::More'           => 0,
        'Test::Deep'           => 0,
        'List::MoreUtils'      => 0,
    },
    requires => {
        'Carp'                 => 0,
        'Moose'                => 0,
        'MooseX::Getopt'       => 0.12,
        'MooseX::SimpleConfig' => 0,
        'List::AllUtils'       => 0,
        'namespace::autoclean' => 0,
    },
    add_to_cleanup     => [ 'App-Genpass-*' ],
    create_makefile_pl => 'traditional',
    create_readme      => 1,
    create_license     => 1,
);

$builder->create_build_script();
