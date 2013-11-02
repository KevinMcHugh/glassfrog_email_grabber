require_relative 'lib/xml_parser'
require_relative 'lib/uri_parser'
require_relative 'lib/circle_grabber'
require_relative 'lib/role_grabber'

class EmailList
  attr_reader :circle, :role, :xml_parser, :uri_parser
  
  DEFAULT_ROLES = {"Facilitators" => "facilitators",
                   "Lead Links" => "lead_links",
                   "Rep Links" => "rep_links",
                   "Secretaries" => "secretaries"}

  def initialize( circle, role = nil, xml_parser = XMLParser.new, uri_parser = URIParser.new )
    @circle = circle
    @role = role 
    @xml_parser = xml_parser
    @uri_parser = uri_parser
  end

  def list_emails
    begin
      if role == nil && DEFAULT_ROLES.keys.include?(circle)
        xml = uri_parser.get_xml( "#{DEFAULT_ROLES[circle]}" )
        email_array = xml_parser.email_map( xml, 'people/person/email' )
        return email_array
      elsif role == nil && !DEFAULT_ROLES.keys.include?(role)
        circle_emails = CircleGrabber.new( uri_parser, xml_parser ).circle_emails( circle )
        existing_roles = RoleGrabber.new( uri_parser, xml_parser ).get_roles( circle )
        return "Circle Members: #{circle_emails}\nRoles: #{existing_roles}"
      else
        return RoleGrabber.new.get_role_emails( circle, role )
      end
    rescue Exception => e
      puts "I errored out :("
      raise e
    end
  end

end

if __FILE__ == $0
  e = EmailList.new( ARGV[0], ARGV[1] )
  puts e.list_emails
end
