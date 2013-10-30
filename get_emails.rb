require_relative 'email_grabber'

circle = ARGV.first
puts GrabberPrinter.new.get_emails circle
