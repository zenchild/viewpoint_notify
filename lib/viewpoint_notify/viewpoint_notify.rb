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
require 'daemontor'
require 'thwait'

class ViewpointNotify::Daemon
	include ViewpointNotify
	include Daemontor
	def initialize
		@threads = ThreadGroup.new
		@status_icon = StatusIcon.new
		t1 = Thread.new { @status_icon.start }
		@threads.add(t1)
		@notifier = Notifier.new(@status_icon.icon)
		@notifier.send_message("test","<a href='http://www.google.com'>Google</a>")
		@watcher = FolderWatcher.new(@notifier)
		t2 = Thread.new { @watcher.start }
		@threads.add(t2)
	end

	# Not much left to do here but wait for the child threads.
	def start
		@threads.list.first.join
	end

	def shutdown
		@watcher.stop
		@notifier.stop
		@status_icon.stop
	end
end
