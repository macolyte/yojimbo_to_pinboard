#Yojimbo to Pinboard

This is an Applescript and Python combo to export your bookmarks from [Yojimbo][1] to [Pinboard][2]. 

All you should have to do is open export_yojimbo_bookmarks.scpt, fill in your username and password at the top, and hit run.

If your links have apostrophes, commas or parentheses everything will come crashing down. I could probably fix this, but I probably won't. 

This was all made possible by [python-pinboard][3].

**DISCLAIMER**: I am a complete hack. This code could destroy your data, kill your dog, or open a black hole that consumes the planet. Edge cases weren't considered and error checking code is not included. Use at your own risk.


[1]: http://www.barebones.com/products/yojimbo/
[2]: https://pinboard.in/
[3]: https://github.com/mgan59/python-pinboard