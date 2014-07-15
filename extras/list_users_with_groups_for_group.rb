#!/usr/bin/env ruby

# Copyright 2014
# Henri Shustak
# Licenced under the GNU GPL v3

# About : This scirpt list_users_with_groups_for_group.rb is a wrapper script to lgfu (list groups for user) 
#         and is designed to find the groups assoiated with a set of users in a group.
#         At present it only supports Mac OS X Open Direcotry. Tested on 10.8 server edition with Open Directory enabled.
#         Chances are you will want to imrpvoe the output for your requirements. Also, this algorhtem is 
#         mighty slow. If you are able to improve the effecncy of this scrip then fork this project and 
#         submit a pull request on git hub : http://www.lucid.technology/tools/osx/lgfu

# Version History
#  1.0 : innitial relsase.

# Note this script will not support the following : 
#   - Group lookups for a user with a UID of 0 will fail
#   - Any lookups for groups with a GID of 0 will also fail
#   - May not find all users within a group an additional script which
#     uses the dsmemberutil command would be required in order to know for sure.

if ARGV.length != 1 
	puts "Usage : list_users_with_grousp_for_group.rb groupname" 
	puts "         # note that this script will not support a GID or UID with 0"
  puts "         # expected output example : username, group1, group2"
  puts "                                     username, group3, group1"
  puts "                                     etc..."
  puts ""
  puts " Note : This wrapper script may not find all users in a specified group"
	exit -1
end

# Internal varibles
group = ARGV[0]

# who is a member of the the group, note see the issues relating to this apparoch within the assosiated "notes_on_commands_used_within_script.txt" file.
group_members = `dscl localhost -read "/LDAPv3/127.0.0.1/Groups/#{group}" Member | awk -F "Member: " '{print $2}'`.split(" ")

# other varibles
exit_status = 0
users_with_issues_detected = []

# process the staff members
group_members.each  do |user| 
	result = `../lgfu.rb "#{user}"`
	result_return_code = $?.exitstatus
	users_with_issues_detected.push(user) if result_return_code != 0 
	exit_status = -1 if result_return_code != 0
	puts "#{result.chomp}"
end

if users_with_issues_detected.length >= 1 
	puts "Users with issues detected :"
	users_with_issues_detected.each do |users_with_issue|
		puts "users_with_issue"
	end
end

exit exit_status



