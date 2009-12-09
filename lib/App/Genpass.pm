package App::Genpass;

use Moose;
use List::AllUtils 'none';

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
    is => 'ro', isa => 'ArrayRef[Str]', default => sub { [ split //, q{oO0l1I} ] }
);

has 'specials' => (
    is => 'ro', isa => 'ArrayRef[Str]', default => sub { [ split //, q{!@#$%^&*()} ] }
);

has [ qw( readable special verify ) ] => ( is => 'ro', isa => 'Bool', default => 1  );

has [ qw( length ) ] => ( is => 'ro', isa => 'Int', default => 10 );

# attributes for the program
has 'configfile' => ( is => 'ro', isa => 'Str' );

our $VERSION = '0.01';

sub BUILD {
    my $self = shift;
}

sub _get_chars {
    my $self  = shift;
    my @chars = ();

    # adding all the combinations
    push @chars, @{ $self->lowercase  },
                 @{ $self->uppercase  },
                 @{ $self->numerical  },
                 @{ $self->specials   },
                 @{ $self->unreadable };

    # removing the unreadable chars
    if ( $self->readable ) {
        @chars = grep {
            local $a = $_;
            none { $a eq $_ } @{ $self->unreadable };
        } @chars;
    }

    return \@chars;
}

sub generate {
    my ( $self, $repeat ) = @_;
    my $EMPTY = q{};
    my @chars = @{ $self->_get_chars };

    $repeat ||= 1;

    # TODO: check the length and num of types

    # generating the password
    for ( 1 .. $repeat ) {
        my $password = $EMPTY;

    }
}

1;

__END__

=head1 NAME

App::Genpass - Quickly create secure passwords

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use App::Genpass;

    my $foo = App::Genpass->new();
    ...

=head1 DESCRIPTION

If you've ever needed to create 10 (or even 10,000) passwords on the fly with varying preferences (lowercase, uppercase, no confusing characters, special characters, minimum length, etc.), you know it can become a pretty pesky task.

This script makes it possible to create flexible and secure passwords, quickly and easily.

At some point it will support configuration files.

=head1 SUBROUTINES/METHODS

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 AUTHOR

Sawyer X, C<< <xsawyerx at cpan.org> >>

=head1 BUGS AND LIMITATIONS

Please report any bugs or feature requests to C<bug-app-genpass at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=App-Genpass>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc App::Genpass


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=App-Genpass>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/App-Genpass>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/App-Genpass>

=item * Search CPAN

L<http://search.cpan.org/dist/App-Genpass/>

=back


=head1 ACKNOWLEDGEMENTS

=head1 LICENSE AND COPYRIGHT

Copyright 2009 Sawyer X.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

