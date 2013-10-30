require 'sinatra'
require 'haml'
require_relative 'email_grabber'


get '/' do
	@members = []
	haml :list
end

post '/' do
	@members = GrabberPrinter.new.get_emails params[:circle]
	haml :list
end