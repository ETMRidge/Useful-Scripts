#!/bin/bash

ip_list=( $( last | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" ) )

for x in "${ip_list[@]}"; do
echo "IP Address: "$x""
curl -G https://api.abuseipdb.com/api/v2/check -s \
  --data-urlencode """ipAddress=$x""" \
  -d maxAgeInDays=90 \
  -d verbose \
  -d confidenceMinimum=0 \
  -H "Key: 5df31c46e180154cce403cbbcfb73f32efac327bb946e5b3b72d562064b75ac22f05b37e3b8088ba" \
  -H "Accept: application/json" | grep -o -w -E -e '"countryName":"([a-zA-Z]+( [a-zA-Z]+)+)",' -e '"countryName":"[a-zA-Z]+",' -e '"abuseConfidenceScore":[0-9]**'
curl -s --request GET \
     --url https://api.greynoise.io/v3/community/"$x" \
     --header 'Accept: application/json' \
     --header 'key: S8axYtuPmhme47Hl9IvyeWS67LDON0QPiuwhndmPul9Zo4c3Cq2itu9HdbZbSzHI' | grep -o -w -E -e '"riot": [a-zA-Z]+,' -e '"noise": [a-zA-Z]+,'
echo ""
done
