#!/opt/local/bin/perl -w
use lib '../lib';

use Test::More tests => 10;
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



$answer = $client->call('subscribe', {list_ids=>[@available_list_ids], fields=> {email=>'sam@parson.com', phone=>'1 234 5678900', twitter=>'sammy', name=>'Сеня Парсон'}});
$result = $answer->{result};
is ($answer->{error}, undef, 'shoudnt have errors');
isnt ($result->{person_id}, '', 'shoudnt be empty');
isnt ($result->{person_id}, 0, 'shoudnt be empty');
# it 'subscribe person to lists' do
#   answer = test_client.subscribe(:list_ids=>available_list_ids, :fields=>{:email=>'sam@parson.com', :phone=>'1 234 5678900',
#    :twitter=>'sammy', :name=>'Сеня Парсон'})
#   answer['result']['person_id'].should be_an_kind_of(Numeric)
# end