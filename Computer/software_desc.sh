#! /bin/sh
set -e
trap 'test $? = 0 || echo "$0 failed!" >& 2' 0
println() {
	printf '%s\n' "$1"
}
single_dep() {
	apt-cache rdepends --installed "$1" | sed 's/^  //; t; d' \
	| LC_COLLATE=C sort -u | {
		n=0
		while read b
		do
			f=$b
			n=`expr $n + 1`
		done
		case $n in
			1) println "$f";;
			*) println "$1"
		esac
	}
}
dpkg_which() {
	c=`command -v -- "$1"`
	c=`readlink -f -- "$c"`
	c=`dpkg -S "$c" | cut -d : -f 1 | head -n 1`
	while :
	do
		case $c in
			*[-.]*) c=`single_dep "$c"`;;
			*) break
		esac
		
	done
	println "$c"
}
distro=`
	lsb_release -i | tr '[:upper:]' '[:lower:]' \
	| sed 's/[[:space:]]\{1,\}/ /g'
`
for pkg
do
	{
		println "$distro"
		apt-cache show "$pkg" 2> /dev/null \
			|| apt-cache show "`dpkg_which "$pkg"`"
	} | awk -F ': ' '
		BEGIN {
			order="Package|Version|Section|distributor id"
			n= split(order, o, "|")
			for (i= 1; i <= n; ++i) {
				f[o[i]]= i; delete o[i]
			}
			OFS= ""
		}
		
		$1 in f {i= $1; $1= ""; v[f[i]]= $0}
	
		END {
			c= v[1]; s= "-"
			for (i= 2; i <= n; ++i) {
				c= c s v[i]; s= "/"
			}
			print c ": "
		}
	'
done
