require 'erb'
require 'open3'
require_relative 'email_grabber'

circle = ARGV.first
renderer = ERB.new(File.read("compose.erb"))
addresses = GrabberPrinter.new.get_emails circle, ENV['GLASSFROG_KEY']
Open3.pipeline_w(["osascript"]) {|i, ts|
  i.puts(renderer.result())
}
