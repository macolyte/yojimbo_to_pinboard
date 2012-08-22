import os
import sys
import pinboard

p = pinboard.open(sys.argv[2], sys.argv[3])
file_name = sys.argv[1] + "export.txt"

with open(file_name) as yojimbo_data:
	bookmarks = yojimbo_data.readlines()

for bookmark in bookmarks:
	bookmark = bookmark.split(",")
	_name = bookmark[0] if bookmark[0] else bookmark[1]
	_url = bookmark[1]
	_tags = bookmark[2].split(":")
	_tags = tuple(_tags)
	p.add(url=_url, description=_name, tags=_tags)

os.remove(file_name)