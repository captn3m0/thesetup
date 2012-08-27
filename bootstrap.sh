#!/bin/sh
command -v lynx >/dev/null 2>&1 || { echo >&2 "This script needs lynx to fetch web-pages. Aborting."; exit 1; }
echo "Creating data directory"
mkdir -p data
cd data
echo "Getting List of interviews"
 lynx --dump http://usesthis.com/interviews/  | awk '/http/{print $2}' | grep -e "http://usesthis.com/interviews/in/\d*" | xargs -i lynx --dump {} | awk '/http/{print $2}'|sort | uniq | grep -e "^http://[0-9a-z\.]*.usesthis.com/$" > list.txt
while read url; do
  echo Downloading $url
  path=${url#http://}
  name=${path%.usesthis.com/}
  wget -q $url -O $name.html
done < list.txt
rm list.txt
