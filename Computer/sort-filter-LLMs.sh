#! /bin/sh
set -e
case $1 in
	title) echo 'LLM Models';;
	filename) echo 'LLM KI Sprachmodelle Reviews.txt';;
	filter) LC_COLLATE=C sort -u;;
	*) false
esac
