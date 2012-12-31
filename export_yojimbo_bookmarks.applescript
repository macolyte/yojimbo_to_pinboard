display dialog "Please enter your Pinboard username:" default answer "" buttons {"Quit", "Continue"} cancel button 1 default button 2
set pinboard_username to (text returned of result)

display dialog "Please enter your Pinboard password:" default answer "" buttons {"Quit", "Continue"} cancel button 1 default button 2 with hidden answer
set pinboard_password to (text returned of result)

tell application "Yojimbo"
	empty trash (* Deleted bookmarks will be exported without this *)
	set exported_bookmark_count to 0
	set bookmarks to every bookmark item
	repeat with bookmark in bookmarks
		set _description to urlencode(name of bookmark) of me
		set _url to urlencode(location of bookmark) of me
		set _tags to name of every tag of bookmark

		set AppleScript's text item delimiters to ","
		set _tags to urlencode(_tags as text) of me

		set _api_response to (do shell script "curl --user " & pinboard_username & ":" & pinboard_password & " 'https://api.pinboard.in/v1/posts/add?description=" & _description & "&url=" & _url & "&tags=" & _tags & "'")

		if _api_response = "401 Forbidden" then display dialog "Invalid Pinboard username/password. Your bookmarks could not be exported." with icon 2 buttons {"Quit"} cancel button 1 default button 1

		if _api_response contains "<result code=\"done\" />" then set exported_bookmark_count to exported_bookmark_count + 1

	end repeat
end tell

if exported_bookmark_count > 1 then
	set bookmark_string to "bookmarks"
else
	set bookmark_string to "bookmark"
end if
display dialog "Successfully exported " & exported_bookmark_count & " " & bookmark_string & " (out of " & (count bookmarks) & ")." buttons {"Awesome!"}

(*
  Pinboard API arguments should be passed URL-encoded.
  A neat Applescript implementation can be found at http://harvey.nu/applescript_url_encode_routine.html and is copied below.
*)
on urlencode(theText)
	set theTextEnc to ""
	repeat with eachChar in characters of theText
		set useChar to eachChar
		set eachCharNum to ASCII number of eachChar
		if eachCharNum = 32 then
			set useChar to "+"
		else if (eachCharNum ­ 42) and (eachCharNum ­ 95) and (eachCharNum < 45 or eachCharNum > 46) and (eachCharNum < 48 or eachCharNum > 57) and (eachCharNum < 65 or eachCharNum > 90) and (eachCharNum < 97 or eachCharNum > 122) then
			set firstDig to round (eachCharNum / 16) rounding down
			set secondDig to eachCharNum mod 16
			if firstDig > 9 then
				set aNum to firstDig + 55
				set firstDig to ASCII character aNum
			end if
			if secondDig > 9 then
				set aNum to secondDig + 55
				set secondDig to ASCII character aNum
			end if
			set numHex to ("%" & (firstDig as string) & (secondDig as string)) as string
			set useChar to numHex
		end if
		set theTextEnc to theTextEnc & useChar as string
	end repeat
	return theTextEnc
end urlencode
