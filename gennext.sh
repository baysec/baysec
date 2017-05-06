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
title: "Next BaySec: $(date -j -r $esecs +'%B %e'$ending', %Y')"
layout: patriothouse
event_summary: Baysec
event_timezone: $TZ
event_start: $(date -j -r $esecs +"%Y%m%dT190000")
event_end: $(date -j -r $esecs +"%Y%m%dT230000")
event_location: Patriot House Pub
created: !!timestamp '$(date -j -r $gensecs +"%Y-%m-%d %H:%M:%S")'
---

Baysec will be at the Patriot House Pub in SF, starting at 7 pm and usually
ending some time after 10 pm.

<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3152.7895438057476!2d-122.40109834914308!3d37.794971618670836!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x80858061009fbe67%3A0xaca3e8d9f06b5f8e!2sPatriot+House+Pub!5e0!3m2!1sen!2sus!4v1483420387349" width="600" height="450" frameborder="0" style="border:0" allowfullscreen></iframe>
EOF
