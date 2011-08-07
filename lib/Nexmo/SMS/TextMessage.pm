package Nexmo::SMS::TextMessage;

use strict;
use warnings;

use Nexmo::SMS::Response;
use Nexmo::SMS::UserAgent;

use LWP::UserAgent;
use JSON::PP;

our $VERSION = '0.01';

my %attrs = (
    text              => 'required',
    from              => 'required',
    to                => 'required',
    server            => 'required',
    username          => 'required',
    password          => 'required',
    status_report_req => 'optional',
    client_ref        => 'optional',
    network_code      => 'optional',
);

for my $attr ( keys %attrs ) {
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
    
    for my $attr ( keys %attrs ) {
        if ( exists $param{$attr} ) {
            $self->$attr( $param{$attr} );
        }
    }
    
    $self->user_agent(
        LWP::UserAgent->new(
            agent => 'Perl module ' . __PACKAGE__ . ' ' . $VERSION,
        ),
    );
    
    return $self;
}

sub user_agent {
    my ($self,$ua) = @_;
    
    $self->{__ua__} = $ua if @_ == 2;
    return $self->{__ua__};
}

sub errstr {
    my ($self,$message) = @_;
    
    $self->{__errstr__} = $message if @_ == 2;
    return $self->{__errstr__};
}

sub send {
    my ($self) = shift;
    
    my %optional;
    $optional{'client-ref'}        = $self->client_ref        if $self->client_ref;
    $optional{'status-report-req'} = $self->status_report_req if $self->status_report_req;
    $optional{'network-code'}      = $self->network_code      if $self->network_code;
    
    my $response = $self->user_agent->post(
        $self->server,
        {
            %optional,
            username => $self->username,
            password => $self->password,
            from     => $self->from,
            to       => $self->to,
            text     => $self->text,
        },
    );
    
    if ( !$response || !$response->is_success ) {
        $self->errstr("Request was not successful: " . $response->status_line);
        warn $response->content if $response;
        return;
    }
    
    my $json            = $response->content;
    my $response_object = Nexmo::SMS::Response->new( json => $json );
    
    return $response_object;
}

sub check_needed_params {
    my ($class,%params) = @_;
    
    my @params_not_ok;
    
    for my $attr ( keys %attrs ) {
        if ( $attrs{$attr} eq 'required' and !$params{$attr} ) {
            push @params_not_ok, $attr;
        }
    }
    
    return join ", ", @params_not_ok;
}

1;