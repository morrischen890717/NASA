#! /usr/bin/env bash
exec 2>&-
if [[ -f $1 || "$1" == "-n" && "$2" -gt 0 && -f $3 ]]; then
	if [ -f $1 ];then
		top_line=10
		filename="$1"
	else
		top_line=$2
		filename="$3"
	fi
	line_num=$(cat "${filename}" | wc -l)
	#echo "line_num = ${line_num}"
	result=$(cat ${filename} | sed 's/^.*GET //g' | sed 's/?.*//g' | sed 's/ HTTP\/1\.1.*//g' | sort | uniq -c | sort -g -r -k 1 | head -n ${top_line})
	#echo "${result}"
	declare -a array
	IFS=$'\n'
	export IFS;
	for i in ${result};
	do
		array+=(${i})
	done
	#printf "%s\n" "${array[@]}"
	declare -a time
	declare -a path
	for i in "${array[@]}";
	do
		time+=($(echo "$i" | awk -v FS=" " '{print $1}'))
		path+=($(echo "$i" | awk -v FS=" " '{print $2}'))
	done
	#printf "%s\n" "${time[@]}"
	#printf "%s\n" "${path[@]}"
	printf "%-35s %-10s %-10s\n" "Path" "Times" "Percentage"
	for (( i=0; i<${top_line}; i++));
	do
		percentage=$(echo "scale=2;${time[i]}*100/${line_num}" | bc)
		printf "%-35s %-10s %-2.2f%%\n" "${path[i]}" "${time[i]}" "${percentage}"
	done
	exit
fi
if [[ "$1" != "-n" || "$1" == "-n" && "$2" -gt 0 && "$3" == "" ]];then
        echo "Usage: csie_analytics.sh [-n count] [filename]"
        exit
fi
if [[ "$1" == "-n" && "$2" -gt 0 && ! -f $3 ]];then
	echo "Error: log file does not exist"
	exit
fi
if [[ "$1" == "-n" && "$(echo "$2" | sed 's/^[-,.,0-9]*//g')" != "" ]];then
	echo "Error: option requires an argument"
	exit
fi
if [ "$1" == "-n" ];then
	if [[ "$2" -lt 0 || "$(echo "$2" | sed 's/^[-,.,0-9]*//g')" == "" ]];then
		echo "Error: line number must be positive integer"
		exit
	fi
fi
#reference:https://blog.longwin.com.tw/2013/03/stdin-stdout-stderr-redirection-2013/
#reference:https://blog.xuite.net/altohorn/linux/17259885-wc+%E8%A8%88%E7%AE%97%E6%AA%94%E6%A1%88%E7%9A%84%E8%A1%8C%E6%95%B8%E3%80%81%E5%AD%97%E6%95%B8%E3%80%81%E4%BD%8D%E5%85%83%E7%B5%84%E6%95%B8
#reference:http://charleslin74.pixnet.net/blog/post/419884702-%5Blinux%5D-%E6%8E%92%E5%BA%8F-sort%E7%9A%84%E7%94%A8%E6%B3%95
#reference:https://blog.csdn.net/naiveloafer/article/details/8783518
#reference:http://smilejay.com/2012/11/floating-point-with-bc-and-awk/
#reference:http://wanggen.myweb.hinet.net/ach3/ach3.html
#reference:https://www.cnblogs.com/jjzd/p/6397495.html

