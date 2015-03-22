#!/usr/bin/env bash

# Build urls
urls=()
for a in A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
do
	urls=(${urls[@]} "http://tempsreel.envibus.fr/list/?com_id=0&letter=$a")
done
echo ${urls[@]}

# Get all urls into one file
wget -O output.html ${urls[@]}

# Create JSON from the "parsed" html
coffee envibusStationGetter.coffee > envibusStations.json