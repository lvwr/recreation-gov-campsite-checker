#!/bin/bash
# Add camping ids to the list below (these can be taken directly from recreation.gov camping site url)
PARKS="232848 232861"

# Set start date, end date and number of nights for search
STARTDATE="2024-05-05"
ENDDATE="2024-09-30"
NIGHTS=2

# Put your e-mail to get notications below.
EMAIL=""

# Put your azure communication service setup info below
CONSTR=""
SENDERADDR=""

for L in $PARKS
do
	python3.9 ./camping.py --parks $L --start-date $STARTDATE --end-date $ENDDATE --nights $NIGHTS --weekends-only | grep "available out" | cut -f1 -d: > $L.new
	sleep 1
	python3.9 ./camping.py --parks $L --start-date $STARTDATE --end-date $ENDDATE --nights $NIGHTS --show-campsite-info --weekends-only >> $L.new
	sleep 1
	if ! cmp -s $L.new $L.last
	then
		python3.9 ./emailnotify.py $L $EMAIL $CONSTR $SENDERADDR
		mv $L.new $L.last
	fi
done
