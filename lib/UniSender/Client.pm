package UniSender::Client;
use base qw(Class::Accessor);
use JSON::XS;
use LWP;
use URI;

__PACKAGE__->follow_best_practice;
__PACKAGE__->mk_accessors( qw(api_key client_ip locale) );

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
	
	$request = {%$params, %$default};
	$query = $self->_make_query($request);
	
	my $url = "http://www.unisender.com/" . $self->get_locale . "/api/$action?$query";
	my $browser = LWP::UserAgent->new;
	my $response = $browser->get( $url );
	my $content = $response->content;
	
	
	my $json_xs = JSON::XS->new();
  $json_xs->utf8(1);
  return $json_xs->decode($content);
}

sub _make_query {
	my $self = shift;
	$params = $_[0];
	my $u = URI->new;
	$u->query_form($params);
	return $u->query;
}

sub _translate_params {
	my $self = shift;
	$params = $_[0];
	my $iparams = {};
	foreach $k (keys %$params){
		$v = $params->{$k};
		$iparams->{$k} = $v;
	}
	return $iparams;
}

# def translate_params(params)
#   params.inject({}) do |iparams, couple|
#     iparams[couple.first] = case couple.last
#     when String
#       URI.encode(couple.last)
#     when Array
#       couple.last.map{|item| URI.encode(item.to_s)}.join(',')
#     when Hash
#       couple.last.each do |key, value|
#         iparams["#{couple.first}[#{key}]"] = URI.encode(value.to_s)
#       end
#       nil
#     else
#       couple.last
#     end
#     iparams
#   end
# end

1;

# private
# 
#   def method_missing(undefined_action, *args, &block)
#     params = (args.first.is_a?(Hash) ? args.first : {} )
#     default_request(undefined_action.to_s.camelize(false), params)
#   end
# 
#   def default_request(action, params={})
#     params = translate_params(params) if defined?('translate_params')
#     params.merge!({'api_key'=>api_key, 'format'=>'json'})
#     query = make_query(params)
#     JSON.parse(open("http://www.unisender.com/#{locale}/api/#{action}?#{query}").read)
#   end
# 

