require_relative 'console_grabber_wrapper'


circle = ARGV.first
result = ConsoleGrabberWrapper.new.get_emails circle, ENV['GLASSFROG_KEY']
error = result[:error]
members = result[:members]
if error
	puts error
else
	puts members
end
