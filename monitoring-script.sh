#!/bin/bash

#List of targets
ips=(  
0.0.0.0
example.com
)

for x in "${ips[@]}"; do #For each entry in the list, run the following command
ping -c 3 "$x" > /dev/null #Ping the entry 3 times, though supress output
if [ $? -eq 1 ]; then #If the exit status is equal to 1, the domain is likely offline
echo "$x" "is offline" 

fi
done
