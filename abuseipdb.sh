#!/bin/bash

ip_list=( $( last -10 | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" ) )

for x in "${ip_list[@]}"; do
curl -G https://api.abuseipdb.com/api/v2/check -s \
  --data-urlencode """ipAddress=$x""" \
  -d maxAgeInDays=90 \
  -d verbose \
  -d confidenceMinimum=0 \
  -H "Key: $API" \
  -H "Accept: application/json" | grep -o -w -E '"abuseConfidenceScore":[0-9]*'
echo "$x"
done
