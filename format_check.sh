#! /usr/bin/env bash
check1=$(echo $1 | sed 's/[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}//g')
check2=$(echo $1 | sed 's/[0-9]\{4\}\.[0-9]\{2\}\.[0-9]\{2\}//g')
check3=$(echo $1 | sed 's/[0-9]\{4\}\/[0-9]\{2\}\/[0-9]\{2\}//g')
check4=$(echo $2 | sed 's/[0-9]\{2\}:[0-9]\{2\}//g')
check5=$(echo $2 | sed 's/[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}//g')
if [ "$check1" == "" ] || [ "$check2" == "" ] || [ "$check3" == "" ]; then
	if [ "$check4" == "" ] || [ "$check5" == "" ]; then
		echo "$1 $2";
	else
		echo "Invalid";
	fi
else
	echo "Invaild";
fi

