#!/usr/bin/env ruby

# Copyright 2014
# Henri Shustak
# Licenced under the GNU GPL v3

# About : This scirpt lgfu (list groups for user) is designed to find the groups assoiated with a user within t
#         the open directoy on a system. At present it only supports mac OS X open direcotry. Tested on 10.8
#         Chances are you will want to imrpvoe the output for your requirements. Also, this algorhtem is 
#         mighty slow. If you are able to improve the effecncy of this scrip then fork this project and 
#         submit a pull request on git hub : http://www.lucid.technology/tools/osx/lgfu
#
# Note this script will not support the following : 
#   - Group lookups for a user with a UID of 0 will fail
#   - Any lookups for groups with a GID of 0 will also fail
#
# Other important notes / points to keep in mind :
#   - Users with multiple short names will have all shortnames listed on the output.
#
# Version History
#  1.0 : innitial relsase.
#  1.1 : added dscl_prefix_path for possible use on non-opendir system
#

if ARGV.length != 1 
	puts "Usage : lgfu.rb username" 
	puts "         # note that this script will not support a GID or UID with 0"
  puts "         # expected output example : username, group1, group2"
	exit -1
end

# Internal varibles
user = ARGV[0]
dscl_prefix_path = "/LDAPv3/127.0.0.1" #switch to /Local/Default/ if you are not running on opendir (untested)
uid = `dscl localhost -read "/Users/#{user}" UniqueID | awk '{print $2}'`.chomp
uid_lookup_return_code = $?.exitstatus
user_shortname = `dscl localhost -read "#{dscl_prefix_path}/Users/#{user}" RecordName | tr -d "\n" | awk -F "RecordName: " '{print $2}'`.chomp
user_shotname_lookup_return_code = $?.exitstatus
users_groups = []
od_groups = `dscl localhost -list #{dscl_prefix_path}/Groups`.split("\n")
output_string = "#{user_shortname.to_s}"
exit_status = 0

# Sanity Check
if (((uid != 0) && (uid_lookup_return_code == 0)) && (("#{user_shortname}" != "") && (user_shotname_lookup_return_code == 0)))
        # check the user for each group
        od_groups.each  do |group|
                user_is_member_of_group = false
                gid = `dscl localhost -read "#{dscl_prefix_path}/Groups/#{group}" PrimaryGroupID | awk '{print $2}'`.chomp
                gid_lookup_return_code = $?.exitstatus
                group_shortname = `dscl localhost -read "#{dscl_prefix_path}/Groups/#{group}" RecordName | tr -d "\n" | awk -F "RecordName: " '{print $2}'`.chomp
                group_shortname_lookup_return_code = $?.exitstatus
                if (((gid != 0) && (gid_lookup_return_code == 0)) && (("#{group_shortname}" != "") && (group_shortname_lookup_return_code == 0)))
                        check_membership_result = `dsmemberutil checkmembership -u #{uid} -g #{gid}`.chomp
                        check_membership_return_code = $?.exitstatus
                        user_is_member_of_group = true if ("#{check_membership_result.to_s}" == "user is a member of the group")
                        users_groups.push("#{group_shortname.to_s}") if user_is_member_of_group
                else
                        puts "ERROR! : Unable to find assosiated GID and/or shortname for \"#{group}\""
                        exit_status = -1
                end
        end
else
        puts "ERROR! : Unable to find assosiated UID and/or shortname for \"#{user}\""
        exit -1
end

users_groups.each do |group2print|
        output_string = output_string + ", #{group2print}"
end

puts "#{output_string}"
exit exit_status


