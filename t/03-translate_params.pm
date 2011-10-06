#!/opt/local/bin/perl -w
use lib '../lib';

use Test::More tests => 2;
use UniSender::Client;

my $client = UniSender::Client->new({api_key => '2pF44VzCfXmNSVOJtMhgBTLzTWlZokU8w'});

$result = $client->_translate_params({});
is (keys %$result, 0, 'should be empty');

$result = $client->_translate_params({a => '123', b => 8});
is (keys %$result, 2, 'should have 2 elements');
is ($result->{a}, '123', 'should have a');
is ($result->{b}, 8, 'should have b');