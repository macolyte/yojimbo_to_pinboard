set PB_USER to "username"
set PB_PASS to "password"

tell application "Finder" to get folder of (path to me) as Unicode text
set workingDir to POSIX path of result
set ex_file to workingDir & "export.txt"

(*
python.py will parse each line of your bookmark export file
and split on this field_delimiter.
*)
set field_delimiter to "PINBOARD!"

(*
Your Yojimbo bookmarks will be exported to export.txt. 1 line = 1 bookmark. I.e.,
<title><field_delimiter><url><field_delimiter><colon_separated_tags>
Here's an example:
The Slow Obviation of YojimboPINBOARD!http://shawnblanc.net/2012/08/the-slow-obviation-of-yojimbo/PINBOARD!hack:awesomeness
*)
tell application "Yojimbo"
	empty trash
	set the_list to every bookmark item
	repeat with _item in the_list
		set _name to name of _item
		set _URL to location of _item
		set _tags to name of every tag of _item

		set old_delim to AppleScript's text item delimiters
		set AppleScript's text item delimiters to ":"
		set _tags to _tags as text
		set AppleScript's text item delimiters to old_delim

		do shell script "echo " & quoted form of _name & field_delimiter & quoted form of _URL & field_delimiter & quoted form of _tags & " >> " & ex_file
	end repeat
end tell

do shell script "python " & workingDir & "import.py " & workingDir & " " & PB_USER & " " & PB_PASS

display dialog "All Done"
