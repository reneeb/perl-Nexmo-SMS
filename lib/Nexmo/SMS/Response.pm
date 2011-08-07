package Nexmo::SMS::Response;

use strict;
use warnings;

use Nexmo::SMS::Response::Message;

use JSON::PP;

our $VERSION = '0.01';

# create getter/setter
my @attrs = qw(json message_count status);

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
    
    return $self if !$param{json};
    
    # decode json
    my $coder = JSON::PP->new->utf8->pretty->allow_nonref;
    my $perl  = $coder->decode( $param{json} );
    
    $self->message_count( $perl->{'message-count'} );
    $self->status( 0 );
    
    # for each message create a new message object
    for my $message ( @{ $perl->{messages} || [] } ) {
        $self->_add_message(
            Nexmo::SMS::Response::Message->new( %{$message || {}} )
        );
    }
    
    return $self;
}

sub messages {
    my ($self) = @_;
    
    return @{ $self->{__messages__} || [] };
}

sub _add_message {
    my ($self,$message) = @_;
    
    if ( @_ == 2 and $message->isa( 'Nexmo::SMS::Response::Message' ) ) {
        push @{$self->{__messages__}}, $message;
        if ( $message->status != 0 ) {
            $self->status(1);
            $self->errstr( $message->status_text . ' (' . $message->status_desc . ')' );
        }
    }
}

sub errstr {
    my ($self,$message) = @_;
    
    $self->{__errstr__} = $message if @_ == 2;
    return $self->{__errstr__};
}

sub is_success {
    my ($self) = @_;
    return !$self->status;
}

sub is_error {
    my ($self) = @_;
    return $self->status;
}

1;