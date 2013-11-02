require 'fast_spec_helper'
require 'uri_parser'

describe URIParser do
  let(:glassfrog_uri) { "a_uri" }
  let(:glassfrog_key) { "a_key" }
  let(:parser) { Class.new }
  let(:path) { "a_path" }
  let(:url) { "www.example.com" }
  let(:parsed_uri) { "parsed_uri" }
  let(:read_uri) { "read_url" }
  let(:generated_url) { "gen_url" }

  subject { described_class.new( parser ) }

  describe "#url_generator" do
    it "spits out a formatted url" do
      stub_const( "URIParser::GLASSFROG_URI", glassfrog_uri )
      stub_const( "URIParser::GLASSFROG_KEY", glassfrog_key )
      subject.url_generator( path ).
        should == "a_uria_path.xml?api_key=a_key"
    end
  end

  describe "#uri_parse" do
    before :each do
      parser.stub( :parse ).and_return parsed_uri
      parsed_uri.stub( :read ).and_return read_uri
      subject.stub( :url_generator ).and_return generated_url
    end

    it "generates the url" do 
      subject.should_receive( :url_generator ).with( url )
      subject.uri_parse url
    end

    it "parses the generated url" do
      parser.should_receive( :parse ).with( generated_url )
      subject.uri_parse url
    end

    it "reads the parsed_uri" do
      parsed_uri.should_receive( :read )
      subject.uri_parse url
    end
  end

  describe "#get_xml" do
    it "parses a uri" do
      subject.should_receive( :uri_parse ).with( path )
      subject.get_xml path
    end
  end
end
