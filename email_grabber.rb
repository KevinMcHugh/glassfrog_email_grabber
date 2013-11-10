require "open-uri"
require 'nokogiri'

class EmailGrabber
	def glassfrog_uri; 'https://glassfrog.holacracy.org/api/v2/'; end
	DEFAULT_ROLES = {"Facilitators" => "facilitators",
		"Lead Links" => "lead_links",
		"Rep Links" => "rep_links",
		"Secretaries" => "secretaries"}
	def default_roles; DEFAULT_ROLES; end
	attr_reader :glassfrog_key
	def initialize key
		@glassfrog_key = key
	end
	def get method
		uri = URI.parse("#{glassfrog_uri}#{method}.xml?api_key=#{@glassfrog_key}").read
	end
	def get_emails_for target_circle
		if !target_circle
			raise ArgumentError.new "Must provide a circle name"
		end
		if default_roles.keys.include? target_circle
			parse_emails get default_roles[target_circle]
		else
			circle_hashes = get_circles
			names_to_ids = {}
			circle_hashes.each { |circle| names_to_ids[circle[:name]] = circle[:id]}
			circle_id = names_to_ids[target_circle]
			raise ArgumentError.new "I don't know that circle" unless circle_id
			parse_emails get "circle/#{circle_id}/mailing_list"		
		end
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
		rescue StandardError => e
			puts e.message
		end
	end
end