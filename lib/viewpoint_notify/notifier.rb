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
require 'rnotify'

class ViewpointNotify::Notifier

	def initialize(status_icon = nil)
		Notify.init( "Notifier" )
		@status_icon = status_icon
	end

	def send_message(subject, message, icon=nil)
		notice = Notify::Notification.new( subject, message, nil, @status_icon)
		notice.timeout = 4000
		notice.show
	end

	def stop
		uninit
	end

	def uninit
		Notify.uninit
	end

end
