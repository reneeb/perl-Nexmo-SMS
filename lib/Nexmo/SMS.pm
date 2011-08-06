package Nexmo::SMS;

use warnings;
use strict;

use Nexmo::SMS::Message;

=head1 NAME

Nexmo::SMS - The great new Nexmo::SMS!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Nexmo::SMS;

    my $foo = Nexmo::SMS->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 function1

=cut

sub new {
    my ($class,%param) = @_;
    
    for my $attr ( keys %param ) {
        
    }
}

=head2 function2

=cut

sub sms {
    my ($self,%param) = @_;
    
    my %types = (
        text   => 'Nexmo::SMS::TextMessage',
        binary => 'Nexmo::SMS::BinaryMessage',
    );
    
    my $type = $param{type} ||
    
    # check for needed params
    
    # create new message
    
    # return message 
}

sub get_balance {
}

sub get_pricing {
}

=head1 AUTHOR

Renee Baecker, C<< <module at renee-baecker.de> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-nexmo-sms at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Nexmo-SMS>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Nexmo::SMS


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Nexmo-SMS>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Nexmo-SMS>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Nexmo-SMS>

=item * Search CPAN

L<http://search.cpan.org/dist/Nexmo-SMS/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2011 Renee Baecker.

This program is released under the following license: artistic_2


=cut

1; # End of Nexmo::SMS
