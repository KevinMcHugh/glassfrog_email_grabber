require 'sinatra'
require 'haml'
require "sinatra/cookies"
require_relative 'email_grabber'
require_relative 'web_grabber_wrapper'


get '/' do
	@members = []
	api_key = cookies[:api_key]
	redirect to('/circles') if api_key
	haml :set_cookie
end

get '/circles' do
	api_key = cookies[:api_key]
	grabber = WebGrabberWrapper.new
	result = grabber.get_emails({ circle: '', api_key: api_key})
	@error = result[:error]
	@members = result[:members]
	@mailto = result[:mailto]
	haml :list
end

post '/circles' do
	circle = params[:circle]
	api_key = cookies[:api_key]
	if !api_key || api_key.empty?
		redirect to('/')
	else
		grabber = WebGrabberWrapper.new
		result = grabber.get_emails({ circle: circle, api_key: api_key})
		@error = result[:error]
		@members = result[:members]
		@mailto = result[:mailto]
	end
	haml :list
end

post '/' do
	response.set_cookie :api_key, params[:api_key]
	haml :list
end