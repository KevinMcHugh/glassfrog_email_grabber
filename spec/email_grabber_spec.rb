require './app'
require 'rspec'

describe EmailGrabber do 

	context "methods" do
		let (:circles) do 
			'<?xml version="1.0" encoding="UTF-8"?>
			<circles type="array">
				<circle>
				    <id type="integer">1960</id>
				    <short-name>JCVD</short-name>
				    <name>Jean Claude Van Damme</name>
			 	</circle>
				<circle>
				    <id type="integer">1947</id>
			    	<short-name>AS</short-name>
			    	<name>Arnold Schwarzenegger</name>
			  	</circle>
			</circles>'
		end
		let(:people) do 
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

		let(:people_result) do 
			["vfries@batmanandrobin.com", "dquaid@totalrecall.com", 
				"tterminator@theterminator.com", "jslater@lastactionhero.com"]
		end

		let(:circles_result) do
			[{:id=>"1960", :name=>"JCVD"}, {:id=>"1947", :name=>"AS"}]
		end

		context "#parse_emails" do
			subject { EmailGrabber.new("").parse_emails(people)}
			it {should == people_result }
		end

		describe "#get_emails_for" do
			def get_emails circle
				EmailGrabber.new("").get_emails_for circle
			end
			context "invalid circles" do
				it "raises an error for nil" do
					expect {get_emails nil}.to raise_error ArgumentError, "Must provide a circle name"
				end
			end
		end

		describe "#get_circles" do
			let(:grabber) { EmailGrabber.new ""}
			before(:all) do
				grabber.stub(:get) {circles}
			end
			subject {grabber.get_circles}
			it {should == circles_result}
		end

	end
end