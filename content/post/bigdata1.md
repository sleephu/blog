---
title: "hadoop Setup Tips"
date: 2019-02-24T20:47:03-08:00

---

**How to Set Up Hadoop Home to use hadoop command directly:**
```
vim ~/.profile
export HADOOP_HOME=/usr/local/bin/hadoop-2.7.1;
export PATH=$PATH:${HADOOP_HOME}/bin;
```
  
```
alias hstart="/usr/local/bin/hadoop-2.7.1/sbin/start-dfs.sh;/usr/local/bin/hadoop-2.7.1/sbin/start-yarn.sh";  
alias hstop="/usr/local/bin/hadoop-2.7.1/sbin/stop-yarn.sh;/usr/local/bin/hadoop-2.7.1/sbin/stop-dfs.sh";
```
  

**Why have to source ~/.profile every time?**

Since ~/.bash_profile exists.

_Solution:_

`echo "source ~/.profile"  >>  .bash_profile`

