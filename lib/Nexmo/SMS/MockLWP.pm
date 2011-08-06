package Nexmo::SMS::MockLWP;

use Nexmo::SMS::UserAgent;
use JSON::PP;

*Nexmo::SMS::UserAgent::post = sub {
    my ($url,$params) = @_;
    
    my $json = do{ undef $/; <DATA> };
    
    my $coder = JSON::PP->new->ascii->pretty->allow_nonref;
    my $perl  = $coder->decode( $json );
    
    my $subhash   = $perl->{$url}->{};
    my $response  = $coder->encode( $subhash );
    
    return $response;
};

1;
__DATA__
{
}