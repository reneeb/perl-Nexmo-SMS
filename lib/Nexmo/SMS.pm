package Nexmo::SMS;

use warnings;
use strict;

use Nexmo::SMS::BinaryMessage;
use Nexmo::SMS::TextMessage;
use Nexmo::SMS::WAPPushMessage;

=head1 NAME

Nexmo::SMS - Module for the Nexmo SMS API!

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';


=head1 SYNOPSIS

This module simplifies sending SMS through the Nexmo API.


    use Nexmo::SMS;

    my $nexmo = Nexmo::SMS->new(
        server   => 'http://test.nexmo.com/sms/json',
        username => 'testuser1',
        password => 'testpasswd2',
    );
    
    my $sms = $nexmo->sms(
        text     => 'This is a test',
        from     => 'Test02',
        to       => '452312432',
    ) or die $nexmo->errstr;
    
    my $response = $sms->send || die $sms->errstr;
    
    if ( $response->is_success ) {
        print "SMS was sent...\n";
    }

=head1 METHODS

=head2 new

create a new object

    my $foo = Nexmo::SMS->new(
        server   => 'http://test.nexmo.com/sms/json',
        username => 'testuser1',
        password => 'testpasswd2',
    );

Those parameters are optional and they are used as defaults for the message objects

=cut

my @attrs = qw(server username password);;

for my $attr ( @attrs ) {
    no strict 'refs';
    *{ __PACKAGE__ . '::' . $attr } = sub {
        my ($self,$value) = @_;
        
        my $key = '__' . $attr . '__';
        $self->{$key} = $value if @_ == 2;
        return $self->{$key};
    };
}

sub new {
    my ($class,%param) = @_;
    
    my $self = bless {}, $class;
    
    for my $attr ( @attrs ) {
        if ( exists $param{$attr} ) {
            $self->$attr( $param{$attr} );
        }
    }
    
    return $self;
}

=head2 sms

Create a new message object or returns C<undef>.

    my $sms = $nexmo->sms(
        text     => 'This is a test',
        from     => 'Test02',
        to       => '452312432',
    ) or die $nexmo->errstr;

Send a binary message

    my $binary = $nexmo->sms(
        type     => 'binary',
        udh      => '06050415811581',   # hex encoded udh
        body     => '0011223344556677', # hex encoded body
        from     => 'Test02',
        to       => '452312432',
    ) or die $nexmo->errstr;
=cut

sub sms {
    my ($self,%param) = @_;
    
    my %types = (
        text    => 'Nexmo::SMS::TextMessage',
        binary  => 'Nexmo::SMS::BinaryMessage',
        wappush => 'Nexmo::SMS::WAPPushMessage',
    );
    
    my $requested_type = $param{type};
    if ( exists $param{type} and !$types{$requested_type} ) {
        $self->errstr("Type $requested_type not supported (yet)!");
        return;
    }
        
    my $type   = $requested_type || 'text';
    my $module = $types{$type};
    
    # check for needed params
    my $sub_name  = 'check_needed_params';
    my $check_sub = $module->can( $sub_name );
    if ( !$check_sub ) {
        $self->errstr("$module does not know about sub $sub_name");
        return;
    }
    
    $param{server}   ||= $self->server;
    $param{username} ||= $self->username;
    $param{password} ||= $self->password;
    
    my $params_not_ok = $module->$sub_name( %param );
    if ( $params_not_ok ) {
        $self->errstr("Check params $params_not_ok");
        return;
    }
    
    # create new message
    my $message = $module->new( %param );
    
    # return message 
    return $message;
}

=head2 errstr

return the "last" error as string.

    print $nexmo->errstr;

=cut

sub errstr {
    my ($self,$message) = @_;
    
    $self->{__errstr__} = $message if @_ == 2;
    return $self->{__errstr__};
}

=head2 get_balance

Not implemented yet...

=cut

sub get_balance {
    warn "not implemented yet\n";
    return;
}

=head2 get_pricing

Not implemented yet...

=cut

sub get_pricing {
    warn "not implemented yet\n";
    return;
}

=head1 Attributes

These attributes are available for C<Nexmo::SMS::TextMessage> objects. For each
attribute there is a getter/setter:

  $nexmo->server( 'servername' );
  my $server = $nexmo->server;

=over 4

=item * password

=item * server

=item * username

=back

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
