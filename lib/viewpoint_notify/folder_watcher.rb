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

	def initialize
		@folders = []
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
		trap("INT", proc { Thread.current.kill } )
		begin
			while run
				load_folders
				@folders.each do |fold|
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
			@folders = [ @@default_folder ]
		else
			@folders = folders.split(/\s*,\s*/)
		end
	end
end

#a = Thread.new {ViewpointNotify::FolderWatch.new}
#puts "Watching folders now"
#a.join
