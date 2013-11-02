require 'nokogiri'

class XMLParser
  attr_reader :driver

  def initialize( driver = Nokogiri::XML )
    @driver = driver
  end

  def xml_parser( unparsed_xml )
    driver.parse( unparsed_xml )
  end

  def xpath_navigator( xml, path )
    emails = xml_parser( xml ).xpath( path )
  end

  def email_map( xml, path )
    email_array = xpath_navigator( xml, path ) 
    email_array.map { |email| "#{email.text}" }
  end

end
