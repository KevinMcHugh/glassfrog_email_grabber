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
	if circle.empty? || params[:api_key].empty?
		@members = ["PLEASE FILL OUT CIRCLE AND KEY"]
		@mailto = nil
	else
		@members = EmailGrabber.new(params[:api_key]).get_emails_for circle
		@mailto = generate_mailto circle, @members
	end
	haml :list
end