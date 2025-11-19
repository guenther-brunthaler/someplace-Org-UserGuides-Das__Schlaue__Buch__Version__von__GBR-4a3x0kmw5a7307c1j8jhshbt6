#! /bin/sh
module_prefix=sort-filter-
module_suffix=.sh

set -e
if ! xset q > /dev/null 2>& 1
then
	once=false
	xmessage() {
		case $1 in
			-*)
				$once && exit
				once=true
				;;
			*) echo "$*" >& 2
		esac
	}
fi
cleanup() {
	rc=$?
	test -n "$T" && rm -- "$T"
	test $rc = 0 || xmessage "$0: Something has gone wrong!"
}
T=
trap cleanup 0
trap 'exit $?' INT TERM QUIT HUP

test $# = 0

self=$0
if test ! -f "$self"
then
	self=`command -v -- "$self"`
	test -f "$self"
fi
case $self in
	/*) ;;
	*) self=`pwd`/$self
esac
absdir=`dirname -- "$self"`; test -d "$absdir"

exec 9< "$self"
flock -n 9
T=`mktemp -- "${TMPDIR:-/tmp}/${0##*/}".XXXXXXXXX`
ls -1 -- "$absdir/$module_prefix"*"$module_suffix" > "$T"
set --
btn=2
buttons=
while IFS= read -r module
do
	eval mod_$btn=\$module
	f=`sh -- "$module" filename`
	test -f "$f"
	eval file_$btn=\$f
	f=`sh -- "$module" title`
	buttons=$buttons${buttons:+,}$f:$btn
	btn=`expr $btn + 1`
done < "$T"
buttons=$buttons${buttons:+,}Quit:1
: aha
while
	xmessage -buttons "$buttons" "Select file to sort (again)."
	btn=$?
	test $btn != 1
do
	eval module=\$mod_$btn
	eval f=\$file_$btn
	sh -- "$module" filter < "$f" > "$T"
	cp -- "$T" "$f" # Make sure to break hard links.
done
