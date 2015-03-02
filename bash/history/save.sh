#!/bin/bash

date '+%F %T';
cat /home/alex/.bash_history | perl -pe 's/^#(1[0-9]{9})\n/\1 /' | perl -MPOSIX -pe 'if ( ($t) = /(1[0-9]+)/ ) { s/$t/strftime("%F %T", localtime($t))/e }' | sort | tee /home/alex/history/`date +%F`.history.sh | cut -c-10 | uniq -c;
find /home/alex/history/ -mtime +14 -name *.history.sh -exec gzip {} +;
