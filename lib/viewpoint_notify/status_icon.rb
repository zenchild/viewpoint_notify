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
require 'gtk2'

class ViewpointNotify::StatusIcon

	attr_reader :icon
	def initialize
		@icon = Gtk::StatusIcon.new
		pic = Gdk::Pixbuf.new(File.dirname(__FILE__) + "/../../icons/lighthouse.png", 32, 32)
		@icon.pixbuf = pic
		@icon.tooltip = 'Viewpoint Message Notifier'
	end

	def start
		trap("INT", proc { Thread.current.kill } )
		begin
			Gtk.main
		ensure
			Gtk.main_quit
		end
	end

	def stop
		Gtk.main_quit
	end

end
