#!/opt/local/bin/perl -w
use lib '../lib';

use Test::More tests => 12;
use UniSender::Client;

my $client = UniSender::Client->new({api_key => '2pF44VzCfXmNSVOJtMhgBTLzTWlZokU8w'});

$answer = $client->call('getLists');
$result = $answer->{result};

@available_list_ids = map($_->{id}, @$result);

$answer = $client->call('createEmailMessage', {sender_name=>'Ваня Петров', sender_email=>'uni.sender.gem@gmail.com',
subject=>'You need your stuff', list_id=>$available_list_ids[-1], lang=>'en',
body=>"Привет дорогой друг! Тебе одиноко? Купи продукт от фирмы FooCompany и почувствуй себя счастливым."});
$result = $answer->{result};
isnt ($result, '', 'shoudnt be empty');
is ($answer->{error}, undef, 'shoudnt have errors');
isnt ($result->{message_id}, '', 'shoudnt be empty');
isnt ($result->{message_id}, 0, 'shoudnt be empty');


$answer = $client->call('createSmsMessage', {sender=>'Tester',
list_id=>$available_list_ids[-1],body=>"Просто смска with foo message"});
$result = $answer->{result};
isnt ($result, '', 'shoudnt be empty');
is ($answer->{error}, undef, 'shoudnt have errors');
isnt ($result->{message_id}, '', 'shoudnt be empty');
isnt ($result->{message_id}, 0, 'shoudnt be empty');

$answer = $client->call('createSmsMessage', {sender=>'1 234 4567890',
list_id=>$available_list_ids[-1],body=>"Просто смска with foo message"});
$result = $answer->{result};
isnt ($result, '', 'shoudnt be empty');
is ($answer->{error}, undef, 'shoudnt have errors');
isnt ($result->{message_id}, '', 'shoudnt be empty');
isnt ($result->{message_id}, 0, 'shoudnt be empty');