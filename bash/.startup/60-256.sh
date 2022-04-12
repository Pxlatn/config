# Make gnome-terminal and xterm use 256 colours...
#	if [[ -n "$DISPLAY" && "$TERM" == "xterm" ]]; then
#		if [[ "$COLORTERM" == "gnome-terminal" ]]; then
#			export TERM="gnome-256color";
#		else
#			export TERM="xterm-256color";
#		fi;
#	fi;

# Just filter for the only non-256 terminal I use.
if [[ "$TERM" != "linux" ]]; then
	export TERM="screen-256color";
fi;
