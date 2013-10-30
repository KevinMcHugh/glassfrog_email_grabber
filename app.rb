require 'sinatra'
require 'haml'
require_relative 'email_grabber'


get '/' do 
	@members = GrabberPrinter.new.get_emails "Operations"
	haml :list
end