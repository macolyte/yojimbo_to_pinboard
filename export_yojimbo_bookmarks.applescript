set PB_USER to "username"
set PB_PASS to "password"

tell application "Finder" to get folder of (path to me) as Unicode text
set workingDir to POSIX path of result
set ex_file to workingDir & "export.txt"

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
		
		do shell script "echo " & quoted form of _name & "," & quoted form of _URL & "," & quoted form of _tags & " >> " & ex_file
	end repeat
end tell

do shell script "python " & workingDir & "import.py " & workingDir & " " & PB_USER & " " & PB_PASS

display dialog "All Done"