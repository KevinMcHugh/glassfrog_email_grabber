require_relative 'email_grabber'

def glassfrog_uri; 'https://glassfrog.holacracy.org/api/v2/'; end
def glassfrog_key; ENV['GLASSFROG_KEY']; end
def target_circle; ARGV.first; end

unless glassfrog_key
    abort "Environment didn't contain a GLASSFROG_KEY, did you export it?"
end
grabber = EmailGrabber.new glassfrog_key, glassfrog_uri
begin 
	puts grabber.get_emails_for target_circle
rescue StandardError => e
	puts e.message
end