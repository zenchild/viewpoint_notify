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
require 'gtk2'
require 'rnotify'
require 'launchy'

class ViewpointNotify::Notifier

	# See http://www.galago-project.org/specs/notification/0.9/x211.html for more info
	@@notice_category = "email"

	def initialize(status_icon = nil)
		Notify.init( "Notifier" )
		@status_icon = status_icon
	end

	def send_message(subject, message, icon=nil)
		notice = Notify::Notification.new( subject, message, nil, @status_icon)
		if( message =~ /href/ )
			aproc = get_action_proc(message)

			notice.add_action("Open in OWA","Open in OWA", aproc) do |name, data|
				data.call
				Gtk.main_iteration
			end

			lproc = get_light_proc(message)
			notice.add_action("Open","Open", lproc) do |name, data|
				data.call
				Gtk.main_iteration
			end
		end
		notice.category = @@notice_category
		notice.timeout = 4000
		notice.show
	end

	def stop
		warn "Stopping ViewpointNotify::Notifier"
		uninit
	end

	private

	# Parses the link out of the message
	def parse_link(message)
		message.sub(/^.*<a href=.([^>]+).>.*$/m,'\1')
	end

	# Create a Proc that opens the message in OWA
	def get_action_proc(message)
		link = parse_link(message)
		proc { Launchy.open(link) }
	end

	# Create a Proc that opens a Gtk window with the body of the message
	def get_light_proc(message)
		link = parse_link(message)
		proc {
			win = Gtk::Window.new("Full Message")
			swin = Gtk::ScrolledWindow.new
			textb = Gtk::TextBuffer.new
			textb.text = message
			text = Gtk::TextView.new(textb)
			text.editable = false
			#win.signal_connect( "destroy" ) { Gtk.main_quit }
			hints = Gdk::Geometry.new
			hints.base_width  = 800
			hints.base_height = 600
			hints.max_width = 1024
			hints.max_height = 960
			win.set_geometry_hints(win, hints, Gdk::Window::HINT_MAX_SIZE |
														 Gdk::Window::HINT_BASE_SIZE )
			win.set_default_size(800,600)
			swin.add(text)
			win.add(swin)
			win.show_all
		}
	end

	def uninit
		Notify.uninit
	end

end
