#!/bin/bash

for arg in $@; do
	vim -u NONE -c "helptags $arg" -c q;
done;
