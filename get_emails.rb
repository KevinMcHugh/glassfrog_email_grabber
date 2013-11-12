require_relative 'console_grabber_wrapper'


circle = ARGV.first
result = ConsoleGrabberWrapper.new.get_emails circle, ENV['GLASSFROG_KEY']
error = result[:error]
members = result[:members]
puts error if error
puts members if members
