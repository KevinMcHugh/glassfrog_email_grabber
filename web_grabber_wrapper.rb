class WebGrabberWrapper
	attr_reader :error, :members, :mailto
	def get_emails params
		begin
			grabber = EmailGrabber.new(params[:api_key])
			circle = params[:circle]
			@members = grabber.get_emails_for circle
			@mailto = generate_mailto circle, @members
		rescue ArgumentError => e
			@members = grabber.get_circles.map {|circle| circle[:name]}
			@mailto = nil
		rescue StandardError => e
			@error = e.message
			@members = nil
		end
		self
	end

	def generate_mailto circle, members
		mailto = members.reduce("") do |a,i|
			a += "#{i},"
		end.chomp! ","
		subject = "?subject=#{circle}&body=Dear #{circle} Members,"
		mailto + subject.gsub(" ", "%20")
	end	
end
