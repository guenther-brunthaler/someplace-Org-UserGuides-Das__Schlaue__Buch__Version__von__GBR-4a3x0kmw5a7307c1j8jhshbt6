#! /bin/sh
# v2023.124

die() {
	echo "ERROR: $*" >& 2
	false
}

run() {
	if test -n "$dry"
	then
		echo "SIMULATION: $*" >& 2
	else
		"$@"
	fi
}

unspecified_action() {
	die "No operation specified!"
}

list_groups() {
	sed 's/^[^[:space:]]\{1,\}[[:space:]]\{1,\}'`:
		`'\(\({[^}]*}\)\{1,\}\)\{1,\}.*/\1/; t 1; d;'`:
		`' :1; s/}{/}\n{/g' \
		"$file" | sort -u
}

set -e
trap 'echo "Failed!" >& 2' 0
dry=
file='Software Reviews.txt'
action=unspecified_action
while getopts nlf: OPT
do
	case $OPT in
		f) file=$OPTARG;;
		n) dry=Y;;
		l) action=list_groups;;
		*) false
	esac
done
"$action"
trap - 0
