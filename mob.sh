#!/bin/bash

# $TERM variable may be missing when called via desktop shortcut
CurrentTERM=$(env | grep TERM)
if [[ $CurrentTERM == "" ]]; then
	notify-send --urgency=critical "$0 needs to be run from terminal"
	exit 1
fi

printf " 1) adb \t 2) rsync\nChoose utility: "
read utility

if ! ([ $utility = 1 ] || [ $utility = 2 ]); then
	echo "Your input was not correct"
	exit
fi

if [ $utility = 2 ]; then
	read -p "Termux username: " user
	read -p "Phone IP address: " ip_addr
	read -p "Output folder: " outputFolder
fi

outputFolder="$PWD/data/"
if [ ! -d "$outputFolder" ]; then
	printf "$outputFolder doesn't exist\nCreating $outputFolder"
	mkdir -p "$outputFolder"
fi

case $utility in
1)
	list="adb shell ls -a /sdcard/"
	;;

2)
	list="ssh $user@$ip_addr -p 8022 ls -a /sdcard/"
	;;
esac

IFS=$'\n' read -r -d '' -a items < <(($list) && printf '\0')

for items in ${!items[@]}; do
	printf "%d: %s\n" $items "${items[$items]}"
done

echo "Choose files to backup seperated by space (ex. 1 2 3): "
read -a arr

case $utility in
1)
	sd_dir="/sdcard/"
	;;

2)
	sd_dir=":/sdcard/"
	;;
esac

str=""
for i in "${arr[@]}"; do
	str+="${sd_dir}/${items[$i]} "
done

#
# echo $cmd1
# $cmd1

case $utility in
1)
	cmd1="adb pull -a -z brotli $str $outputFolder"
	;;

2)
	cmd1="rsync -zavh --update --info=progress2 -e 'ssh -p 8022' ${user}@${ip_addr}${str} $outputFolder"
	;;
esac

echo $cmd1
eval "$cmd1"
