#!/bin/bash

hash_list=( $(cat hash.txt) )# This by default will go line by line as it's a list.

for x in "${hash_list[@]}"; do
echo "" # Space to make it readable.
echo "hash: "$x""

curl --request GET \
  --url https://www.virustotal.com/api/v3/search?query="$x" \
  --header 'x-apikey: ()' #API key goes here, remove the brackets once entered.

sleep 15 #Sleeps for 15 seconds to ensure it efficiently meets the API limit.
done
