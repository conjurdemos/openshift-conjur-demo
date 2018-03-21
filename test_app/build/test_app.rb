#!/opt/conjur/embedded/bin/ruby

require 'conjur-api'
require 'restclient'
require 'json'

Conjur.configuration.apply_cert_config!
Conjur.configuration.appliance_url = ENV['CONJUR_APPLIANCE_URL']
Conjur.configuration.account = ENV['CONJUR_ACCOUNT']

def retrieve_secret variable_id
  @api = Conjur::API.new_from_key ENV['CONJUR_AUTHN_LOGIN'], ENV['CONJUR_AUTHN_API_KEY']
  @api.variable(variable_id).value
end

variable_id = "db/password"

while true
  begin
    password = retrieve_secret(variable_id)
    puts "Database password : #{password}"
    $stdout.flush
  rescue RestClient::ResourceNotFound
    puts $!
    $stderr.puts "Value for #{variable_id.inspect} was not found. Is the variable created, and is the secret value added?"
  end
  sleep 5
end
