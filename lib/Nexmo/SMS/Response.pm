package Nexmo::SMS::Response;

use strict;
use warnings;

use JSON::PP;

our $VERSION = '0.01';

# create getter/setter
my @attrs = qw();


sub new {
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