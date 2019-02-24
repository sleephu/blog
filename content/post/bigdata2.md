---
title: "hadoop localhost 9000 connection refused"
date: 2019-02-24T21:25:03-08:00
---

debug process:
```
telnet localhost 9000
netstat -lpten | grep 9000
```
It did return something, meaning network connection is working fine.

### Final reason:

**core-site.xml**
```
<configuration>

<property>

<name>hadoop.tmp.dir</name>

<value>/usr/local/bin/hadoop-2.7.1/tmp</value>

</property>

</configuration>
```
1. Lack of closed </configuration> tap.
2. the tmp directory didn’t exist

### Summary:

1. Check network.

2. Check hadoop configuration (hadoop-env.xml/core-site.xml/hdfs-site.xml/mapred-site.xml.tmplate)

3. Always close hadoop services, or it will aways get swap file.


