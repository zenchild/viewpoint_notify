#############################################################################
# Copyright © 2009 Dan Wanek <dan.wanek@gmail.com>
#
#
# This file is part of Viewpoint Notify.
# 
# Viewpoint Notify is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published
# by the Free Software Foundation, either version 3 of the License, or (at
# your option) any later version.
# 
# Viewpoint Notify is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
# Public License for more details.
# 
# You should have received a copy of the GNU General Public License along
# with Viewpoint Notify.  If not, see <http://www.gnu.org/licenses/>.
#############################################################################
require 'rubygems'
require 'viewpoint'

class ViewpointNotify::FolderWatcher

	@@default_folder = "Calendar"

	def initialize(notifier)
		@notifier = notifier
		@folders = []
		@vp = Viewpoint::ExchWebServ.instance
		@vp.authenticate
		@vp.find_folders
	end

	def start
		watcher
	end


	def stop
		# TODO: run clean-up tasks here
	end


	private

	# Main method that does all the folder polling.  You can optionally set a
	# time in seconds between polling for updates.
	def watcher(polling_time=60)
		run = true
		load_folders
		trap("INT", proc { Thread.current.kill } )
		begin
			while run
				@folders.each do |fold|
					resp = fold.check_subscription
          if( fold.instance_of?(Viewpoint::CalendarFolder) )
            if(resp.key?(:createdEvent) )
              resp[:createdEvent].each do |ev|
                msg = fold.get_event(ev[:item_id]) if ev.key?(:item_id)
                next if msg.nil?
                msg_summary = msg.subject +
                  "<a href='https://webmail.state.nd.us/owa/?ae=Item&a=open&t=#{msg.item_class}&id=#{msg.owa_id}'>OWA Link</a>"
                @notifier.send_message(msg.sender, msg_summary)
              end
            end
          else
            if(resp.key?(:newMailEvent) )
              resp[:newMailEvent].each do |ev|
                msg = fold.get_message(ev[:item_id]) if ev.key?(:item_id)
                next if msg.nil?
                msg_summary = msg.subject +
                  "<a href='https://webmail.state.nd.us/owa/?ae=Item&a=open&t=#{msg.item_class}&id=#{msg.owa_id}'>OWA Link</a>"
                @notifier.send_message(msg.sender, msg_summary)
              end
            end
					end
				end
				sleep polling_time
			end
		ensure
			stop
		end
	end


	def load_folders
		props = SOAP::Property.load(File.new("#{ENV['HOME']}/.viewpointrc"))
		folders = props['vpnotify.folders']
		if( folders.nil? )
			@folders = [ @vp.get_folder(@@default_folder) ]
		else
			folders.split(/\s*,\s*/).each do |fold|
				@folders << @vp.get_folder(fold)
			end
		end

		@folders.each do |fold|
			fold.subscribe
		end
	end
end

#a = Thread.new {ViewpointNotify::FolderWatch.new}
#puts "Watching folders now"
#a.join
