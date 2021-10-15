#!/bin/bash
for i in $(seq 1 255) #for every number between 1 and 255
do
curl --request GET --url https://api.greynoise.io/v3/community/23.170.128."$i" #Send a get request to greynoise. The "$i" is the output of line 2 and defines the last octet of the IP.

done
