#!/bin/sh
#
# Script to generate the next Baysec meetup
#

set -e

dir=content/meetups
TZ=America/Los_Angeles
export TZ

i=$(grep -h event_start "$dir"/2* | sort | tail -n 1)
i=${i#*: }

esecs=$(date -j -v1d -v+1m -v+tue -v+2w -f %Y%m%dT%H%M%S "$i" +%s)
gensecs=$(date +%s)

echo Generating meetup at $(date -r $esecs)

dmnth=$(date -j -r $esecs +"%d" )
case $dmnth in
01|21|31)
	ending="st";;
02|22)
	ending="nd";;
03|23)
	ending="rd";;
*)
	ending="th";;
esac

cat <<EOF > "$dir/$(date -j -r $gensecs +"%Y-%m-%d")-$(date -j -r $esecs +"%B").html"
---
title: $(date -j -r $esecs +"%B %Y") Baysec
layout: patriothouse
event_summary: Baysec
event_timezone: $TZ
event_start: $(date -j -r $esecs +"%Y%m%dT190000")
event_end: $(date -j -r $esecs +"%Y%m%dT230000")
event_location: Patriot House Pub
created: !!timestamp '$(date -j -r $gensecs +"%Y-%m-%d %H:%M:%S")'
---

# $(date -j -r $esecs +"%B %e$ending, %Y")

Baysec will be at the Patriot House Pub and starts at 7pm.
EOF
