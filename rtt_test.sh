#! /usr/bin/env bash
declare -a urls
k=0
filename="$1"
exec < ${filename}
while read line
do
	a=$(echo "$line" | grep -o "=")
	if [ "${a}" == "=" ]; then
		line=$(echo "${line}" | awk -v FS="= " '{print $2}')
		urls+=(${line})
		k=$((k+1))
	fi
done
#echo ${urls[@]}
declare -a rtt
#a=$(ping -c 3 -q ${urls[0]})
#a=$(echo "${a}" | sed '2,4d')
#echo "${a}"
#time=$(echo "${a}" | awk -v FS="/" '{print $6}')
#time=$(echo "${time}" | sed '1d')
#echo "${time}"
#url=$(echo "${a}" | sed '2,5d' | awk '{print $2}')
#echo "${url}"
declare -a result
for (( i=0; i<${k}; i++));
do
	a=$(ping -c 3 -q ${urls[i]})
	exec 2>&-
	a=$(echo "${a}" | sed '2,4d')
	time=$(echo "${a}" | awk -v FS="/" '{print $6}')
#	time=$(echo "${a}" | awk -F"/" '{print $6}')
	time=$(echo "${time}" | sed '1d')
	if [ "${time}" != "" ]; then
		result+=("${urls[i]} ${time}")
	fi
done
printf "%s\n" "${result[@]}" | sort -g -k 2
#for i in {0..15};
#do
#	a=$(`ping -c 3 -q ${urls[i]}`)
#	a=$(echo "a" | sed '2,5d')
#done
#echo "${rtt[0]}"
#reference:https://blog.gtwang.org/linux/linux-sort-command-tutorial-and-examples/
#reference:https://askubuntu.com/questions/859905/display-a-sorted-array
#reference:http://www.runoob.com/linux/linux-shell-printf.html
#reference:https://noootown.wordpress.com/2017/10/17/awk-useful-usage/
#reference:http://linux.vbird.org/linux_basic/0330regularex.php#awk
#reference:http://linux.vbird.org/linux_basic/0330regularex.php#sed_line_add
#reference:https://ithelp.ithome.com.tw/articles/10099558
#reference:https://codertw.com/%E5%89%8D%E7%AB%AF%E9%96%8B%E7%99%BC/393640/
#reference:http://wanggen.myweb.hinet.net/ech2/ech2.html?MywebPageId=201931551588168379#exec_fd
#reference:https://blog.apokalyptik.com/2007/10/24/bash-tip-closing-file-descriptors/
#reference:http://note.qidong.name/2017/07/bash_stdout_stderr/
#reference:http://linux.vbird.org/linux_basic/0320bash/csh/no3-2.html

