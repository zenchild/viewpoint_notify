require File.dirname(__FILE__) + '/spec_helper.rb'

# Time to add your specs!
# http://rspec.info/
describe "Tests for libnotify actions" do
	before(:all) do
		@notifier = ViewpointNotify::Notifier.new
	end

	it "cause libnotify to pop-up a message" do
		@notifier.send_message("Rspec1", "Test from Rspec\n<a href='http://www.google.com'>Google</a>")
		sleep 5
	end

	after(:all) do
		@notifier.stop
	end
end
