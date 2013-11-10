require "open-uri"
require 'nokogiri'

class EmailGrabber
	def glassfrog_uri; 'https://glassfrog.holacracy.org/api/v2/'; end
	def default_roles; {"Facilitators" => "facilitators",
		"Lead Links" => "lead_links",
		"Rep Links" => "rep_links",
		"Secretaries" => "secretaries"}
	end
	attr_reader :glassfrog_key
	def initialize key
		@glassfrog_key = key
	end
	def get method
		uri = URI.parse("#{glassfrog_uri}#{method}.xml?api_key=#{@glassfrog_key}").read
	end
	def get_emails_for target_circle
		if default_roles.keys.include? target_circle
			parse_emails get default_roles[target_circle]
		else
			circle_id = get_id_of_circle target_circle, get_circles
			raise ArgumentError.new "I don't know that circle" unless circle_id
			parse_emails get "circle/#{circle_id}/mailing_list"		
		end
	end

	def get_id_of_circle target_circle, circles
		names_to_ids = {}
		circles.each { |circle| names_to_ids[circle[:name]] = circle[:id]}
		names_to_ids[target_circle]
	end

	def get_circles
		circles_xml = get("circle")
		circles = Nokogiri::XML.parse(circles_xml).xpath("circles/circle")
		circles.map do |circle|
			{id: circle.xpath('id').text, name: circle.xpath('short-name').text}
		end
	end

	def no_circle_specified
		message = "please specify a circle from the below:\n"
		get_circles.each {|circle| message << "#{circle[:name]}\n"}
		message
	end

	def parse_emails circle_xml
		emails = Nokogiri::XML.parse(circle_xml).xpath("people/person/email")
		emails.map {|email| "#{email.text}"}
	end
end

class GrabberPrinter

	def get_emails target_circle, glassfrog_key
		unless glassfrog_key
		    abort "Environment didn't contain a GLASSFROG_KEY, did you export it?"
		end
		grabber = EmailGrabber.new glassfrog_key
		begin 
			grabber.get_emails_for target_circle		
		rescue ArgumentError => ae
			result = "Something went wrong. Here's a list of circles I know about."
			grabber.get_circles.each {|circle| result += " \n " + circle[:name]}
			raise ArgumentError.new result
		end
	end
end