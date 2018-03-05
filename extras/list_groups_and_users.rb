#!/usr/bin/env ruby

# Copyright 2014
# Henri Shustak
# Licenced under the GNU GPL v3

# About : This script list_groups_and_users.rb prints out open directory groups and their members.
#         You will most likely wish to alter the output formating for your requirements. At present 
#         this script only supports Mac OS X Open Direcotry. It has been tested on 10.8 server 
#         edition with Open Directory enabled.
#
#         Chances are you will want to imrpvoe the output for your requirements. More information about
#         the project this script relates to as well as the latest version of this script is availible from : 
#         http://www.lucid.technology/tools/osx/lgfu

# Version History
#  1.0 : innitial relsase.
#  1.1 : added dscl_prefix_path for possible use on non-opendir system

dscl_prefix_path = "/LDAPv3/127.0.0.1" #switch to /Local/Default/ if you are not running on opendir (untested)
od_groups = `dscl localhost -list #{dscl_prefix_path}/Groups`.split("\n")

od_groups.each do |group|

 # who is a member of the the group, note see the issues relating to this apparoch within the assosiated "notes_on_commands_used_within_script.txt" file.
	group_members = `dscl localhost -read "#{dscl_prefix_path}/Groups/#{group}" Member 2> /dev/null | awk -F "Member: " '{print $2}'`.split(" ")
	
	# build output string which will include name of group and the memebers
	output_line = ""
	output_line = "#{group} -"
	group_members.each do |member|
		output_line = "#{output_line} #{member}"
	end

	puts output_line

end

exit 0
