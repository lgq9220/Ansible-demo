#!/bin/bash

hostsStr=$1
serviceHostsFile=$2
serviceInstances=$3

hostsList=($hostsStr)

serviceHostsList=()
for line in $(cat $serviceHostsFile); do
	serviceHostsList[${#serviceHostsList[*]}]=$line
done

serviceCount=${#serviceHostsList[*]}

addList=''
if [ "$serviceCount" -lt "$serviceInstances" ]; then
	for host in ${hostsList[*]}; do
		exist=$(echo "${serviceHostsList[*]}" | grep $host)
		if [ ! -n "$exist" ]; then
			if [ ! -n "$addList" ]; then
				addList=$host
			else
				addList=$addList,$host
			fi
			((serviceCount++))
		fi
		if [ "$serviceCount" -eq "$serviceInstances" ]; then
			break;
		fi
	done
fi

delList=''
if [ "$serviceCount" -gt "$serviceInstances" ]; then
	for host in ${serviceHostsList[*]}; do
		if [ ! -n "$delList" ]; then
			delList=$host
		else
			delList=$delList,$host
		fi
		((serviceCount--))
		if [ "$serviceCount" -eq "$serviceInstances" ]; then
			break;
		fi
	done
fi

if [ -n "$addList" ]; then
	echo "deploy $addList"
elif [ -n "$delList" ]; then
	echo "terminal $delList"
else
	echo "empty"
fi