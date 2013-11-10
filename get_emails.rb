require_relative 'email_grabber'

begin
	circle = ARGV.first
	puts GrabberPrinter.new.get_emails circle, ENV['GLASSFROG_KEY']	
rescue StandardError => e
	puts e.message
end