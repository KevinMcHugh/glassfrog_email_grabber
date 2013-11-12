class WebGrabberWrapper
	def get_emails params
		result = {}
		begin
			grabber = EmailGrabber.new(params[:api_key])
			circle = params[:circle]
			members = grabber.get_emails_for circle
			result[:members] = members
			result[:mailto] = generate_mailto circle, members
		rescue ArgumentError => e
			result[:members] = grabber.get_circles.map {|circle| circle[:name]}
			result[:error] = e.message
		rescue StandardError => e
			result[:error] = e.message
		end
		result
	end

	def generate_mailto circle, members
		mailto = members.reduce("") do |a,i|
			a += "#{i},"
		end.chomp! ","
		subject = "?subject=#{circle}&body=Dear #{circle} Members,"
		mailto + subject.gsub(" ", "%20")
	end	
end
