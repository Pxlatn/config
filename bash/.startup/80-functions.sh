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

mkcd() {
	f="$1";
	for i in `seq 1 $#`; do
		mkdir -v "$1";
		shift;
	done;
	cd "$f";
}

cdtmp() {
	cd "$( mktemp -d )";
}

# Echo to stderr
echoerr() {
	cat <<< "$@" 1>&2;
}
