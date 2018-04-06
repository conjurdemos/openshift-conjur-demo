#!/usr/bin/env ruby

require 'sinatra'

enable :logging

get '/' do
  begin
    ENV["DB_PASSWORD"]
  rescue
    $stderr.puts $!
    $stderr.puts $!.backtrace.join("\n")
    halt 500, "Error: #{$!}"
  end
end
