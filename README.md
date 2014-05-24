# Twitchemoticons.com

build_emotes.pl fetches global emote list from Twitch API, reads emotes.sub for
code replacements and writes HTML code for the emote list to stdout.
index.html.m4 is an [M4](http://en.wikipedia.org/wiki/M4_(computer_language))
template for the final index.html that calls the build_emotes.pl script to
fill in the emote list.

Codes to be changed should be added to or changed in emotes.sub

## Building
$m4 index.html.m4 > index.html

