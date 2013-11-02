require_relative 'uri_parser'
require_relative 'xml_parser'
require_relative 'circle_grabber'

class RoleGrabber
  attr_reader :circle_hash, :parser, :emailer

  def initialize( parser = URIParser.new, emailer = XMLParser.new, circle_hash = CircleGrabber.new.circle_id_hash )
    @parser = parser
    @emailer = emailer
    @circle_hash = circle_hash
  end

  def get_role_emails circle, role
    requested_role = role_member_hash( circle, role, circle_hash )
    requested_role[:people].map do |id| 
      get_person_email id
    end
  end

  def get_person_email id  
    xml = parser.get_xml "person/#{id}"
    emailer.xpath_navigator( xml, 'person/email' ).text
  end

  def role_member_hash( circle, role, hash = circle_hash )
    circle_id = circle_hash[circle]
    xml = parser.uri_parse( "circle/#{circle_id}/roles" )
    email_array = emailer.xpath_navigator( xml, 'circle/role' )
    role_array = email_array.map do |role|
      { role: role.xpath('./name').text,
        people: role.xpath('./filled-by').children.xpath('./id').map {|id| id.text } }
    end
    role_array.detect { |hash| hash[:role].eql?(role) } 
  end

  def get_roles( circle, hash = circle_hash )
    circle_id = circle_hash[circle]
    xml = parser.uri_parse( "circle/#{circle_id}/roles" )
    email_array = emailer.xpath_navigator( xml, 'circle/role' )
    role_array = email_array.map do |role|
      role.xpath('./name').text
    end
    role_array
  end

end
