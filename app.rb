# require './config'
require 'sinatra'
require 'omniauth'
require 'omniauth-twitter'
require 'dotenv'
require 'twitter'

Dotenv.load

configure do
  enable :sessions

  use OmniAuth::Builder do
    provider :twitter, ENV['CONSUMER_KEY'], ENV['CONSUMER_SECRET']
  end

  Twitter.configure do |config|
    config.consumer_key = ENV['CONSUMER_KEY']
    config.consumer_secret = ENV['CONSUMER_SECRET']
  end
end

get "/" do
  erb :index
end

get '/auth/:provider/callback' do
  session[:user_token] = request.env['omniauth.auth']['credentials']['token']
  session[:user_secret] = request.env['omniauth.auth']['credentials']['secret']
  redirect('/tweet')
end

get '/tweet' do
  erb :tweet
end

post '/tweet' do
  user = Twitter::Client.new(
    oauth_token: session[:user_token],
    oauth_token_secret: session[:user_secret]
    )
  user.update(params[:tweet])
  redirect('/')
end

get '/logout' do
  session.clear
  redirect('/')
end

# OmniAuth will make this for us
# get "/auth/:provider" do
# end
