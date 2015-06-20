require 'rubygems'
require 'bundler'
Bundler.require
Dotenv.load
require "sinatra"
require "sinatra/reloader" if development?
require "twilio-ruby"

set :bind, '0.0.0.0'

Twilio.configure do |config|
  config.account_sid = ENV['TWILIO_SID']
  config.auth_token = ENV['TWILIO_TOKEN']
end

def twilio_client
  @client ||= Twilio::REST::Client.new
end

post '/sendurl' do
  send_to = params["from"] || params["web_to"]
  begin
    twilio_client.messages.create(
      from: ENV['TWILIO_NUMBER'],
      to: send_to,
      body: ENV['MESSAGE']
    )
  rescue
    fail = ENV["FAIL_URL"] || "/?fail=true"
    redirect fail
    return
  end
  goto = ENV["SUCCESS_URL"] || "/?success=true"
  redirect goto
end

get '/' do
  erb :demo
end