# lgfu  #

<h1><img src="http://store.apple.com/Catalog/US/Images/pdp-guest-network-badge.png" valign="middle"/></h1>

About
--------

This is an open source (GNU GPL v3 or later) project which is designed to provide you with a list of groups a user belongs to on OS X system(s).

License: [GNU GPL v3 or later][1]


Usage Instructions
---------

chmod +x ./lgfu.rb<br>
./lgfu.rb myusernme

Project Overview and Notes.
---------

  -  There are notes and wrapper script(s) located within the extras directory.
  	- "notes_on_commands_used_within_script.txt" provides a break down of various commands used within the script.
	  - Check if a user is a member of a group 
	  - List all groups
	  - List all users
	  - List all users in a group (probably not all of them)
	  - Obtain User Unique ID 
	  - Obtain User Short Name
	  - Obtain Group Primary ID 
	  - Obtain Group Short Name
  	- "list_users_with_groups_for_group.rb" will (when provided with a group as the first argument) list all users in that group and also all the groups that user is a part of within the open directory.
  -  Should you wish to use this script it is important that you adhear to the licence agreement.


  [1]: www.gnu.org/copyleft/gpl.html

