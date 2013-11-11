require 'sinatra'
require 'haml'
require_relative 'email_grabber'

get '/' do
	@members = []
	haml :list
end

post '/' do
	circle = params[:circle]
	if params[:api_key].empty?
		@error = "please enter an api key"
		@members = nil
	else
		grabber = WebGrabberWrapper.new
		@error = grabber.error
		@members = grabber.members
		@mailto = grabber.mailto
	end
	haml :list
end