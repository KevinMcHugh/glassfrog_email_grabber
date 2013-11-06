require './app'
require 'rspec'

describe EmailGrabber do 

	context "methods" do
		subject {EmailGrabber.new "key", "uri"}
		let(:xml) do 
			'<?xml version="1.0" encoding="UTF-8"?>
			<people type="array">
			  <person>
			    <id type="integer">1997</id>
			    <name>Victor Fries</name>
			    <email>vfries@batmanandrobin.com</email>
			  </person>
			  <person>
			    <id type="integer">1990</id>
			    <name>Douglas Quaid</name>
			    <email>dquaid@totalrecall.com</email>
			  </person>
			  <person>
			    <id type="integer">1984</id>
			    <name>The Terminator</name>
			    <email>tterminator@theterminator.com</email>
			  </person>
			  <person>
			    <id type="integer">1993</id>
			    <name>Jack Slater</name>
			    <email>jslater@lastactionhero.com</email>
			  </person>
			</people>'
		end

		let(:result) do 
			["vfries@batmanandrobin.com", "dquaid@totalrecall.com", 
				"tterminator@theterminator.com", "jslater@lastactionhero.com"]
		end

		context "#parse_emails" do
			subject { EmailGrabber.new("", "").parse_emails(xml)}
			it {should == result }
		end
	end
end