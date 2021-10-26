#!/bin/bash

ip_list=( $( last -10 | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" ) )

for x in "${ip_list[@]}"; do
curl -G https://api.abuseipdb.com/api/v2/check -s \
  --data-urlencode """ipAddress=$x""" \
  -d maxAgeInDays=90 \
  -d verbose \
  -d confidenceMinimum=0 \
  -H "Key: 5df31c46e180154cce403cbbcfb73f32efac327bb946e5b3b72d562064b75ac22f05b37e3b8088ba" \
  -H "Accept: application/json" | grep -o -w -E '"abuseConfidenceScore":[0-9]*'
echo "$x"
done
