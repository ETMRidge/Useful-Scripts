#!/bin/bash

hash_list=( $(cat hash.txt) ) #| grep -Ei '*\n' | sort -u ) )

for x in "${hash_list[@]}"; do
echo "hash: "$x""

curl --request GET \
  --url https://www.virustotal.com/api/v3/search?query="$x" \
  --header 'x-apikey: 0b37182ad661937789a806373b76984c379c9f061c48bb59e96f6e108cfb672a'
done
