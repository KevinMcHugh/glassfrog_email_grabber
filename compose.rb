require 'erb'
require 'open3'
require_relative 'console_grabber_wrapper'

circle = ARGV.first
renderer = ERB.new(File.read("compose.erb"))
result = ConsoleGrabberWrapper.new.get_emails circle, ENV['GLASSFROG_KEY']
error = result[:error]
members = result[:members]
if error
	puts error
else
	Open3.pipeline_w(["osascript"]) {|i, ts|
		i.puts(renderer.result())
	}
end