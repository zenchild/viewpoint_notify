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
$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module ViewpointNotify
	VERSION = '0.0.1'
end

require 'viewpoint_notify/status_icon'
require 'viewpoint_notify/notifier'
require 'viewpoint_notify/folder_watcher'
require 'viewpoint_notify/viewpoint_notify'


begin
	vpn = ViewpointNotify::Daemon.new
	vpn.start
ensure
	vpn.shutdown
end
