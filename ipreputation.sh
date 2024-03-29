#!/bin/bash

ip_list=( $( cat TEXTFILE.txt | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | sort -u ) )  #Edit the command where last -5 is.  It will work on files using cat.

{
for x in "${ip_list[@]}"; do
echo "IP Address: "$x""
curl -G https://api.abuseipdb.com/api/v2/check -s \
  --data-urlencode """ipAddress=$x""" \
  -d maxAgeInDays=90 \
  -d verbose \
  -d confidenceMinimum=0 \
  -H "Key: " \
  -H "Accept: application/json" | grep -o -w -E -e '"countryName":"([a-zA-Z]+( [a-zA-Z]+)+)",' -e '"countryName":"[a-zA-Z]+",' -e '"abuseConfidenceScore":[0-9]**'
curl -s --request GET \
     --url https://api.greynoise.io/v3/community/"$x" \
     --header 'Accept: application/json' \
     --header 'key: S8axYtuPmhme47Hl9IvyeWS67LDON0QPiuwhndmPul9Zo4c3Cq2itu9HdbZbSzHI' | grep -o -w -E -e '"riot": [a-zA-Z]+,' -e '"noise": [a-zA-Z]+,'
echo ""
done
} | tee output.txt  #Taking all output from the above greps and putting it into output.txt

rule_it_out_number=( $( grep -Ei '"riot": true,' output.txt | wc -l ) ) #Grepping for riot and counting how many can be ruled out.
rule_it_out_list=($( grep -B 5 '"riot": true,' output.txt | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | sort -u ) ) #Gathering a list of RIOT IP's
potential_malicious_ip=( $( grep -E -B 5 '"abuseConfidenceScore":[1-9]+' output.txt | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | sort -u ) ) #Gathering a list of IP's with abuseipdb scores over >=1
potential_mal_number=( $( grep -E '"abuseConfidenceScore":[1-9]+' output.txt | wc -l ) ) #Getting the number of IP's with abuseipdb scores over >=1
totalip=( $( cat output.txt | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | wc -l ) )

echo "Total number of IP's:"
echo "$totalip"

echo "Rule out the following $rule_it_out_number IP's:"

for x in "${rule_it_out_list[@]}"; do #For every IP in the RIOT list echo it.
echo "$x"
done

echo "The following $potential_mal_number IP's have an abuse score above 0 and should be investigated:"

for x in "${potential_malicious_ip[@]}"; do #For every IP in the malicious IP list echo it
echo "$x"
done
