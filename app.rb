require 'sinatra'
require 'haml'
require_relative 'email_grabber'


get '/:circle' do 
	@members = GrabberPrinter.new.get_emails params[:circle]
	haml :list
end