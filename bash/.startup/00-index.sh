#!/bin/bash

for file in $(ls ~/.startup); do
	if [[ $file != '00-index.sh' ]]; then
		source ~/.startup/$file;
	fi;
done;
