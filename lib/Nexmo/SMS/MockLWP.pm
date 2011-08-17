package Nexmo::SMS::MockLWP;

=head1 NAME

Nexmo::SMS - Module for the Nexmo SMS API!

=head1 VERSION

Version 0.01

=head1 DESCRIPTION

This module mocks POST requests. It exists only for the unit tests!

=cut

use LWP::UserAgent;
use HTTP::Response;
use JSON::PP;

use strict;
use warnings;

no warnings 'redefine';

our $VERSION = 0.01;

*LWP::UserAgent::post = sub {
    my ($object,$url,$params) = @_;
    
    my $json = do{ undef $/; <DATA> };
    
    my $coder = JSON::PP->new->ascii->pretty->allow_nonref;
    my $perl  = $coder->decode( $json );
    my $from  = $params->{from};
    
    my $subhash   = $perl->{$url}->{$from};
    my $response  = $coder->encode( $subhash );
    
    my $http_response = HTTP::Response->new( 200 );
    $http_response->content( $response );
    
    return $http_response;
};

1;

=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2011 Renee Baecker.

This program is released under the following license: artistic_2


=cut

__DATA__
{
    "http://rest.nexmo.com/sms/json" : {
        "Test01" : {
            "message-count":"1",
            "messages":[
              {
              "status":"0",
              "message-id":"message001",
              "client-ref":"Test001 - Reference",
              "remaining-balance":"20.0",
              "message-price":"0.05",
              "error-text":""
              }
            ]
        },
        "Test03" : {
            "message-count":"1",
            "messages":[
              {
              "status":"4",
              "message-id":"message001",
              "client-ref":"Test001 - Reference",
              "remaining-balance":"20.0",
              "message-price":"0.05",
              "error-text":""
              }
            ]
        }
    },
    "http://test.nexmo.com/sms/json" : {
        "Test02" : {
            "message-count":"2",
            "messages":[
              {
              "status":"0",
              "message-id":"message002",
              "client-ref":"Test002 - Reference",
              "remaining-balance":"10.0",
              "message-price":"0.15",
              "error-text":""
              },
              {
              "status":"0",
              "message-id":"message001",
              "client-ref":"Test001 - Reference",
              "remaining-balance":"20.0",
              "message-price":"0.05",
              "error-text":""
              }
            ]
        }
    }
}