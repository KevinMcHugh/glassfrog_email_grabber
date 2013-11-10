require './app'
require 'rspec'

describe GrabberPrinter do 
	let(:circles) do
		[{id: "1960", name: "JCVD"}, {id: "1947", name: "AS"}]
	end
	let(:error_message) do
		"Something went wrong. Here's a list of circles I know about. \n JCVD \n AS"
	end
	describe '#get_emails' do
		before(:each) do
			EmailGrabber.any_instance.stub(:get_emails_for).and_raise(ArgumentError.new)
			EmailGrabber.any_instance.stub(:get_circles).and_return(circles)
		end
		def get_emails  
			GrabberPrinter.new.get_emails nil, ""
		end
		it "raises an exception" do
			expect {get_emails}.to raise_error ArgumentError, error_message
		end
	end
end