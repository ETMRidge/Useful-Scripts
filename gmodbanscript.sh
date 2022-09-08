#!/bin/bash
ip_list=( $( cat /home/Ridge/output.txt | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | sort -u ) )
firstname=( $( cat /home/Ridge/firstnames.txt | sort -u ) )
lastname=( $( cat /home/Ridge/lastnames.txt | sort -u ) )
{
for i in ${firstname[*]}
do
iptables -F INPUT
grep -Ei "$i" /var/lib/pterodactyl/volumes/d2356e2d-d9f6-4c41-bcff-fcdbba8efc5f/garrysmod/data/doslistener.txt
done
} | sort -u > /home/Ridge/banfirst.txt
{
for x in ${lastname[*]}
do
grep -Ei "$x" /home/Ridge/banfirst.txt
done
} | sort -u > /home/Ridge/output.txt

for c in ${ip_list[*]}
do
iptables --append INPUT --protocol all --src $c --jump DROP
done
