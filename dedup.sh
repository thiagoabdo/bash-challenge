#!/bin/bash

true=0
false=1

fake_ip() {
	ip=$1

	if [[ ! "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
		return $true
	fi
	IFS='.' read -ra ip_split <<< "${ip}"
	for i in "${ip_split[@]}"; do
		if [ "$i" -gt 255 ]; then
			return $true
		fi
		if [ "$i" -lt 0 ]; then
			return $true
		fi
	done
	return $false
}


# Redirect STDOUT
# Close STDOUT file descriptor
exec 1<&-
# Open STDOUT as $LOG_FILE file for read and write.
exec 1<> /tmp/output_1.txt




file=$1
re='^-?[0-9]+$'

declare -a visto

while read line; do 
	if [[ $(echo $line | cut -d. -f1) =~ $re ]]; then
		# start with a number, so it is probably a IP
		IFS=' ' read -ra line_split <<< $(echo "${line}" |tr '\t' ' ')
		ip=${line_split[0]}
		if fake_ip ${ip}; then
			if [[ ! " ${visto[@]} " =~ " ${ip} " ]]; then
				visto+=("$ip")
				echo $line
			fi
		else
			echo $line
		fi
	else
		#true
		echo $line
	fi
done < ${file}
