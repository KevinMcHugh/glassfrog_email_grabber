require 'sinatra'
require 'haml'
require_relative 'email_grabber'
require_relative 'web_grabber_wrapper'


get '/' do
	@members = []
	haml :list
end

post '/' do
	circle = params[:circle]
	api_key = params[:api_key]
	if !api_key || api_key.empty?
		@error = "please enter an api key"
		@members = nil
	else
		grabber = WebGrabberWrapper.new
		result = grabber.get_emails({ circle: circle, api_key: api_key})
		@error = result[:error]
		@members = result[:members]
		@mailto = result[:mailto]
	end
	haml :list
end