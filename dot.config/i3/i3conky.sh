#!/bin/bash

# Plan
#	config
#		calls ~/.i3/i3conky.sh | i3bar | ~/.i3/handle_input.sh
#	setup.sh
#		populate HW locations, e.g. BAT0? BAT1?
#		gets called if ~/.i3/conkyrc does not exist
#	~/.i3/conkyrc
#		built by setup.sh
#		populates at the very least, name, instance and fulltext for each datum
#	~/.i3/i3conky.sh
#		prints i3bar header
#		runs conky
#		potentially triggers setup.sh
#	~/.i3/handle_input.sh
#		receives output from i3bar
#			json formatted user input messages
#		safe to run against unexpected values

# reload conky with `killall -SIGHUP conky`

echo -e '{"version": 1}\n[\n[]';
conky -c $(dirname $0)/conkyrc;
