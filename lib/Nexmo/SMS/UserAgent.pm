package Nexmo::SMS::UserAgent;

use strict;
use warnings;

use LWP::UserAgent;

sub new {
    my ($class) = @_;
    
    my $self = bless {}, $class;
    return $self;
}

sub post {
}

1;