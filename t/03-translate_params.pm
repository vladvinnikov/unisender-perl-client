#!/opt/local/bin/perl -w
use lib '../lib';

use Test::More tests => 11;
use UniSender::Client;

my $client = UniSender::Client->new({api_key => '2pF44VzCfXmNSVOJtMhgBTLzTWlZokU8w'});

$result = $client->_translate_params({});
is (keys %$result, 0, 'should be empty');

$result = $client->_translate_params({a => '123', b => 8});
is (keys %$result, 2, 'should have 2 elements');
is ($result->{a}, '123', 'should have a');
is ($result->{b}, 8, 'should have b');

$result = $client->_translate_params({a => [123, 244], b => 8});
is (keys %$result, 2, 'should have 2 elements');
is ($result->{a}, '123,244', 'should have a array');
is ($result->{b}, 8, 'should have b value');

$result = $client->_translate_params({a => {email => 'd@d.com', name => 'name'}, b => 8, c => [1,2]});
is (keys %$result, 3, 'should have 3 elements');
is ($result->{b}, 8, 'should have b');
is ($result->{sciped_key}, 'a[email]=d%40d.com&a[name]=name', 'should have a hash');
is ($result->{c}, '1,2', 'should have c array');