#!/opt/local/bin/perl -w
use lib '../lib';

use Test::More tests => 6;
use UniSender::Client;

isa_ok(UniSender::Client->new, 'UniSender::Client');

my $client = UniSender::Client->new({api_key => 'abcdfgh'});
is  ( $client->get_api_key, 'abcdfgh', 'should set api_key' );
is  ( $client->get_locale, 'en', 'should set default locale to en' );

$client = UniSender::Client->new({api_key => 'abcdfgh', locale => 'ru'});
is  ( $client->get_locale, 'ru', 'should set non default locale' );

$client = UniSender::Client->new;
my $answer = $client->getList();
is   ($answer->{code}, 'invalid_api_key', 'should have invalid api key');
isnt ($answer->{error}, '', 'should have error description');