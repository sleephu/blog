#!/bin/sh

echo "Deleting old publication"
rm -rf public

# content update
hugo

echo "deploy"
git add -A
git commit -m "update"
git push -u origin master

