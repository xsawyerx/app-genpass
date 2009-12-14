package App::Genpass;

use Moose;
use List::AllUtils qw( any none shuffle );

# attributes for password generation
has 'lowercase' => (
    is => 'rw', isa => 'ArrayRef[Str]', default => sub { [ ( 'a'..'z' ) ] }
);

has 'uppercase' => (
    is => 'rw', isa => 'ArrayRef[Str]', default => sub { [ ( 'A'..'Z' ) ] }
);

has 'numerical' => (
    is => 'rw', isa => 'ArrayRef[Str]', default => sub { [ ( 0 .. 9 ) ] }
);

has 'unreadable' => (
    is      => 'ro',
    isa     => 'ArrayRef[Str]',
    default => sub { [ split //, q{oO0l1I} ] },
);

has 'specials' => (
    is      => 'ro',
    isa     => 'ArrayRef[Str]',
    default => sub { [ split //, q{!@#$%^&*()} ] },
);

has [ qw( readable special verify ) ] => (
    is => 'ro', isa => 'Bool', default => 1
);

has [ qw( length ) ] => ( is => 'ro', isa => 'Int', default => 10 );

# attributes for the program
has 'configfile' => ( is => 'ro', isa => 'Str' );

our $VERSION = '0.03';

sub _get_chars {
    my $self      = shift;
    my @all_types = qw( lowercase uppercase numerical specials );
    my @chars     = ();
    my @types     = ();

    # adding all the combinations
    foreach my $type (@all_types) {
        if ( my $ref = $self->$type ) {
            push @chars, @{$ref};
            push @types, $type;
        }
    }

    # removing the unreadable chars
    if ( $self->readable ) {
        my @remove_chars = (
            @{ $self->unreadable },
            @{ $self->specials   },
        );

        @chars = grep {
            local $a = $_;
            none { $a eq $_ } @remove_chars;
        } @chars;

        # removing specials
        pop @types;
    }

    # make both refs
    return [ \@types, @chars ];
}

sub generate {
    my ( $self, $repeat ) = @_;

    my $length        = $self->length;
    my $verify        = $self->verify;
    my @passwords     = ();
    my @verifications = ();
    my $EMPTY         = q{};

    my ( $char_types, @chars ) = @{ $self->_get_chars };

    my @char_types   = @{$char_types};
    my $num_of_types = scalar @char_types;

    if ( $num_of_types > $length ) {
        die <<"_DIE_MSG";
You wanted a longer password that the variety of characters you've selected.
You requested $num_of_types types of characters but only have $length length.
_DIE_MSG
    }

    $repeat ||= 1;

    # each password iteration needed
    foreach my $pass_iter ( 1 .. $repeat ) {
        my $password  = $EMPTY;
        my $char_type = shift @char_types;

        # generating the password
        while ( $length > length $password ) {
            my $char = $chars[ int rand @chars ];

            # for verifying, we just check that it has small capital letters
            # if that doesn't work, we keep asking it to get a new random one
            # the check if it has large capital letters and so on
            if ( $verify && $char_type ) {
                # verify $char_type
                while ( ! any { $_ eq $char } @{ $self->$char_type } ) {
                    $char = $chars[ int rand @chars ];
                }

                $char_type = scalar @char_types > 0 ? shift @char_types : '';
            }

            $password .= $char;
        }

        # since the verification process creates a situation of ordered types
        # (lowercase, uppercase, numerical, special)
        # we need to shuffle the string
        $password = join '', shuffle( split //, $password );

        $repeat == 1 && return $password;

        push @passwords, $password;

        @char_types = @{$char_types};
    }

    return wantarray ? @passwords : \@passwords;
}

1;

__END__

=head1 NAME

App::Genpass - Quickly create secure passwords

=head1 VERSION

Version 0.03

=head1 SYNOPSIS

    use App::Genpass;

    my $genpass = App::Genpass->new();
    print $genpass->generate, "\n";

    $genpass = App::Genpass->new( readable => 0, length => 20 );
    print map { "$_\n" } $genpass->generate(10);

=head1 DESCRIPTION

If you've ever needed to create 10 (or even 10,000) passwords on the fly with
varying preferences (lowercase, uppercase, no confusing characters, special
characters, minimum length, etc.), you know it can become a pretty pesky task.

This script makes it possible to create flexible and secure passwords, quickly
and easily.

At some point it will support configuration files.

=head1 SUBROUTINES/METHODS

=head2 new

Creates a new instance. It gets a lot of options.

=head2 generate

This method generates the password.

=head1 AUTHOR

Sawyer X, C<< <xsawyerx at cpan.org> >>

=head1 BUGS AND LIMITATIONS

Please report any bugs or feature requests to C<bug-app-genpass at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=App-Genpass>.
I will be notified, and then you'll automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc App::Genpass


You can also look for information at:

=over 4

=item * Github: App::Genpass repository

L<http://github.com/xsawyerx/app-genpass>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=App-Genpass>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/App-Genpass>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/App-Genpass>

=item * Search CPAN

L<http://search.cpan.org/dist/App-Genpass/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2009 Sawyer X.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

