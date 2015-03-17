# Wait until time in HHMM format
wait() {
	until (( 10#`date +%H%M` == 10#$1 )); do sleep 1s; done;
}

# Convert all [0-9]{10} strings into iso-8601 format
epoch() {
	oform='%FT%H:%M:%S';
	if [[ $# > 0 ]]; then
		oform="$1";
	fi;
	while read line; do
		for epoch in $(echo $line | grep -oE "[0-9]{10}"); do
			tm=$(date "+${oform}" -d @$epoch);
			line=$(echo $line | sed "s/$epoch/$tm/g");
		done;
		echo -e $line;
	done;
}

div() {
	seq $1 | sed "s/.*/$1 \/ &/" | bc -l | sed 's/\.*00*$//' | nl | grep -v '\.'
}

# Create new file in the ~/bin/ dir
newbin() {
	touch ~/bin/$1;
	chmod 755 ~/bin/$1;
	vim ~/bin/$1;
}

# Wait for process
pwait() {
	while pgrep "$1" >/dev/null; do
		sleep 1s;
	done;
	notify-send "$1 ended.";
	echo "$1 ended.";
}

# Start SimpleHTTPServer
www() {
	echo http://$(ifconfig eth0 | egrep -io "inet addr:[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | tr -d 'inet addr:'):8000/;
	python -m SimpleHTTPServer;
}

# Echo to stderr
echoerr() {
	cat <<< "$@" 1>&2;
}
