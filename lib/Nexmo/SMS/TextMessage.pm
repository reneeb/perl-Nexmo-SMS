package Nexmo::SMS::TextMessage;

use strict;
use warnings;

use Nexmo::SMS::UserAgent;
use JSON::PP;

our $VERSION = '0.01';

my @attr = qw();

sub new {
    my ($class,%param) = @_;
    
    my $self = bless {}, $class;
    
    for my $attr ( @attr ) {
        if ( exists $param{$attr} ) {
            $self->$attr( $param{$attr} );
        }
    }
    
    $self->user_agent(
        Nexmo::SMS::UserAgent->new,
    );
    
    return $self;
}

sub send {
    my ($self) = shift;
    
    $self->user_agent->post(
        $self->url,
        {
            username => $self->username,
            password => $self->password,
            from
            to
            text
        }
    );
}

1;