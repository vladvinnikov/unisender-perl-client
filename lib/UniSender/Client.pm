# =begin Pod
# 
# =head1 UniSender::Client
# 
# C<UniSender::Client> is a client for unisender.ru JSON api.
# 
# =head1 Synopsis
# 
#     use UniSender::Client;
#     my $client = UniSender::Client->new({api_key => 'YOU_KEY'});
#     my $answer = $client->call('getList');
# 
# =end Pod

package UniSender::Client;
use base qw(Class::Accessor);
use JSON::XS;
use LWP;
use URI::Escape;

__PACKAGE__->follow_best_practice;
__PACKAGE__->mk_accessors( qw(api_key client_ip locale) );

our $AUTOLOAD;

sub AUTOLOAD {
  my $self = shift;  
	my $method = $AUTOLOAD;
	return if $method =~ /^.*::[A-Z]+$/;
	$method =~ s/^.*:://;   # strip fully-qualified portion
	my $params = $_[0] || {};
	return $self->call($method, $params);
}

sub DESTROY {
}

sub get_locale {
	my $self = shift;
	$self->{locale} || 'en';
}

sub call {
	my $self = shift;
  my $method = $_[0];
	my $params = defined($_[1])? $_[1]: {};
	
	my $answer = $self->_default_request($method, $params);
	return $answer;
}

sub _default_request {
	my $self = shift;
	$action = $_[0];
	$params = $_[1];
	$default = {api_key => $self->{api_key}, format => 'json'};
	
	$request = $self->_translate_params({%$params, %$default});
	$query = $self->_make_query($request);
	
	my $url = "http://www.unisender.com/" . $self->get_locale . "/api/$action?$query";
	my $content = $self->_url_content($url);
	
  return $self->_json_decode($content);
}

sub _url_content {
	my $self = shift;
	$url = $_[0];
	my $browser = LWP::UserAgent->new;
	my $response = $browser->get( $url );
	return $response->content;
}

sub _json_decode {
	my $self = shift;
	$content = $_[0];
	my $json_xs = JSON::XS->new();
  $json_xs->utf8(1);
  return $json_xs->decode($content);
}

sub _make_query {
	my $self = shift;
	$params = $_[0];
	$result = join("&", map { "$_=$params->{$_}" } keys %$params);
	$result =~ s/sciped_key=//g;
	return $result;
}

sub _translate_params {
	my $self = shift;
	$params = $_[0];
	my $iparams = {};
	foreach $k (keys %$params){
		$v = $params->{$k};
		if (ref($v) eq 'ARRAY') {
			$v = join(",", map(uri_escape($_), @$v));
		} elsif (ref($v) eq 'HASH') {
			$v = join("&", map { "$k\[$_\]=${ \(uri_escape($v->{$_})) }" } keys %$v);
			$k = 'sciped_key';
		}	else {
			$v = uri_escape($v);
		}
		$iparams->{$k} = $v;
	}
	return $iparams;
}
1;