#!/opt/local/bin/perl -w
use lib '../lib';

use Test::More tests => 19;
use UniSender::Client;

my $client = UniSender::Client->new({api_key => '2pF44VzCfXmNSVOJtMhgBTLzTWlZokU8w'});

$answer = $client->call('getLists');
$result = $answer->{result};

@available_list_ids = map($_->{id}, @$result);

is ($answer->{error}, undef, 'shoudnt have errors');
is  (scalar(@$result), 3, 'should have 3 items' );

$answer = $client->call('createList', {title => 'sample_title'});
$result = $answer->{result};
isnt ($result, '', 'shoudnt be empty');
is ($answer->{error}, undef, 'shoudnt have errors');
isnt ($result->{id}, '', 'shoudnt be empty');
isnt ($result->{id}, 0, 'shoudnt be empty');


$answer = $client->call('createList', {title => 'Кириллица тоже'});
$result = $answer->{result};
isnt ($result, '', 'shoudnt be empty');
is ($answer->{error}, undef, 'shoudnt have errors');
isnt ($result->{id}, '', 'shoudnt be empty');
isnt ($result->{id}, 0, 'shoudnt be empty');


$answer = $client->call('subscribe', {list_ids=>[@available_list_ids], fields=> {email=>'sam@parson.com', phone=>'1 234 5678900', twitter=>'sammy', name=>'Василий Пупкин'}});
$result = $answer->{result};
is ($answer->{error}, undef, 'shoudnt have errors');
isnt ($result->{person_id}, '', 'shoudnt be empty');
isnt ($result->{person_id}, 0, 'shoudnt be empty');

$answer = $client->call('unsubscribe', {contact_type=>'email', contact=>'test@mail.com'});
is ($answer->{error}, undef, 'shoudnt have errors');
isnt ($answer->{result}, undef, 'shoudnt have errors');

$answer = $client->call('unsubscribe', {contact_type=>'phone', contact=>'+1 111 1111111'});
is ($answer->{error}, undef, 'shoudnt have errors');
isnt ($answer->{result}, undef, 'shoud have result');

$answer = $client->call('activateContacts', {contact_type=>'email', contacts=>['test@mail.com', 'john@doe.com'] });
$result = $answer->{result};
isnt ($result, undef, 'shoud have result');
isnt ($result, '', 'shoud have result');
# is ($result->{activated}, 2, 'should have 2 items') falls because of rating or test mode