require 'erb'
require 'open3'
require_relative 'email_grabber'

def glassfrog_uri; 'https://glassfrog.holacracy.org/api/v2/'; end
def glassfrog_key; ENV['GLASSFROG_KEY']; end

renderer = ERB.new(File.read("compose.erb"))
circle = ARGV.first
unless glassfrog_key
    abort "Environment didn't contain a GLASSFROG_KEY, did you export it?"
end
grabber = EmailGrabber.new glassfrog_key, glassfrog_uri
begin
	addresses = grabber.get_emails_for circle
	Open3.pipeline_w(["osascript"]) {|i, ts|
	  i.puts(renderer.result())
	}
rescue StandardError => e
	puts e.message
end