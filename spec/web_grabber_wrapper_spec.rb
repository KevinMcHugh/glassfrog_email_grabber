require './web_grabber_wrapper'
require 'rspec'

describe WebGrabberWrapper do 
	let(:params) {{ circle: nil, api_key: "" }}
	
	describe '#get_emails' do
		context "with no circle input" do
			let(:circles) do
				[{id: "1960", name: "JCVD"}, {id: "1947", name: "AS"}]
			end
			let(:circles_result) {["JCVD", "AS"]}
			before(:each) do
				EmailGrabber.any_instance.stub(:get_emails_for).and_raise(ArgumentError.new)
				EmailGrabber.any_instance.stub(:get_circles).and_return(circles)
			end
			subject { WebGrabberWrapper.new.get_emails params }
			its(:members) {should == circles_result}
			its(:mailto) {should be_nil}
			its(:error) {should be_nil}
		end
		context "with a circle input" do
			let(:mailto_result) {'jkimble@kindergartencop.com?subject=&body=Dear%20%20Members,'}
			let(:people_result) { ["jkimble@kindergartencop.com"] }
			before(:each) do
				EmailGrabber.any_instance.stub(:get_emails_for).and_return(people_result)
			end
			subject { WebGrabberWrapper.new.get_emails params }
			its(:members) {should == people_result}
			its(:error) {should be_nil}
			its(:mailto) {should == mailto_result}
		end
		context "when an unexpected error occurs" do
			let(:error_message) {"SOMETHING_WRONG"}
			before(:each) do
				EmailGrabber.any_instance.stub(:get_emails_for).and_raise(StandardError.new error_message)
			end
			subject { WebGrabberWrapper.new.get_emails params }
			its(:error) {should == error_message}
			its(:members) {should be_nil}
			its(:mailto) {should be_nil}
		end

	end
end