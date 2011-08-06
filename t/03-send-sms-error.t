#!perl -T

use strict;
use warnings;

use Test::More tests => 33;

use Nexmo::SMS::MockLWP;
use Nexmo::SMS;

my $nexmo = Nexmo::SMS->new(
    server   => 'http://rest.nexmo.com/sms/json',
    username => 'testuser',
    password => 'testpasswd',
);

ok( $nexmo->isa( 'Nexmo::SMS' ), '$nexmo is a Nexmo::SMS' );

my $sms = $nexmo->sms(
    text => 'This is a test',
    from => 'Test01',
    to   => 'asdfasdf',
);

ok( $sms->isa( 'Nexmo::SMS::TextMessage' ), '$sms is a Nexmo::SMS::TextMessage' );

my $response = $sms->send;

ok( $response->isa( 'Nexmo::SMS::Response' ), '$response is a Nexmo::SMS::Response' );
ok( !$response->is_success, 'Send SMS was not successful' );
ok( $response->is_error, 'Send SMS failed' );

ok $response->message_count, 1, 'Did send one message';

my @messages = $response->messages;
ok scalar @messages, 1, 'Got result for one message';

my $message = $messages[0];

ok $message->isa( 'Nexmo::SMS::Response::Message' ), 'object is of type Nexmo::SMS::Response::Message';

is $message->status, 4, 'Status is 4';
is $message->message_id, 'message003';
is $message->client_ref, 'Test003 - Reference', 'A client ref given';
is $message->remaining_balance, 20.0, 'Remaining balance: 20.0';
is $message->message_price, 0.05, 'SMS cost 5 cent';
is $message->error_text, '', 'No error text';