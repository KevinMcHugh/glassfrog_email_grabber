require_relative 'email_grabber'

class ConsoleGrabberWrapper

	def get_emails target_circle, glassfrog_key
		unless glassfrog_key
		    abort "Environment didn't contain a GLASSFROG_KEY, did you export it?"
		end
		grabber = EmailGrabber.new glassfrog_key
		begin 
			members = grabber.get_emails_for(target_circle)
			result = {members: members}		
		rescue ArgumentError => ae
			circles = grabber.get_circles.map {|circle| circle[:name]}
			error = "Something went wrong. Here's a list of circles I know about."
			result = {error: error, members: circles}
		end
		result
	end
end