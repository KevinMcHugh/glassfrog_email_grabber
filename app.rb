require 'sinatra'
require 'haml'
require_relative 'email_grabber'

def generate_mailto circle, members
	mailto = @members.reduce("") do |a,i|
		a += "#{i},"
	end.chomp! ","
	subject = "?subject=#{circle}&body=Dear #{circle} Members,"
	mailto + subject.gsub(" ", "%20")
end		

get '/' do
	@members = []
	haml :list
end

post '/' do
	circle = params[:circle]
	@members = GrabberPrinter.new.get_emails circle, params[:api_key]
	@mailto = generate_mailto circle, @members
	haml :list
end