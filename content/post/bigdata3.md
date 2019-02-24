---
title: "Simple bash script to import data into MongoDB"
date: 2019-02-24T22:06:11-08:00
---

**import-data.sh**
```
#! /bin/bash

_dfiles=/Users/computer/Downloads/NYSE/*.csv
for f in $_dfiles
do
mongoimport --type csv -d db -c nyse --headline --file ${f} --jsonArray
done
```
