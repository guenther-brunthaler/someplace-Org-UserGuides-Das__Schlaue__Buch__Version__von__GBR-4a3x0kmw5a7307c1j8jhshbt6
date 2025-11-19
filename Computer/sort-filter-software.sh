#! /bin/sh
set -e
case $1 in
	title) echo 'Software Reviews';;
	filename) echo 'Software Reviews.txt';;
	filter) LC_COLLATE=C sort -u;;
	*) false
esac
