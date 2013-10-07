require 'open3'
require 'erb'
renderer = ERB.new(File.read("compose.erb"))
circle = ARGV.first
addresses,status = Open3.capture2("ruby get_emails.rb #{circle}")
addresses = addresses.split(/\n/)
Open3.pipeline_w(["osascript"]) {|i, ts|
  i.puts(renderer.result())
}
