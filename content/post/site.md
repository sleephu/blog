---
title: "如何最快搭建个人网站"
date: 2019-02-23T20:52:19-08:00
---

# Hugo + Github Page + Travis
## Introduction
 **Hugo + Github 搭建免费个人网站**
 
 我搭建个人网站的时候看了很多相关的教程，但是每次（是的，我搭建了很多次）总有各种各样的问题，特别是我很长一段时间不写博客之后，就忘记如何正确部署发布了 (😓)，所以又重新搭建。

每次搭建都会学到新知识点，这次打算**总结**一下，造福...未来的我自己。

## Preparation 

 - [ ] Github account
 - [ ] Hugo download
 
 网上很多tutorial会详细介绍，在这里就不赘述了。

## Fastest way

**小白速成：最快，的搭建过程** 

以下内容大多数参考这个[tutorial](https://segmentfault.com/a/1190000012975914)， 强烈推荐！
### Step 1: 在本地建一个Hugo Site 并安装主题
#### 安装
环境：macOS

```
brew install hugo

# 检查安装成功
hugo version 
```
#### 新建site
```
hugo new site blog
cd blog
git init
#Congratulations! Your new Hugo site is created in /Users/sleephu/Dropbox/website/blog.

#Just a few more steps and you're ready to go:
#
#1. Download a theme into the same-named folder.
#   Choose a theme from https://themes.gohugo.io/, or
#   create your own with the "hugo new theme <THEMENAME>" command.
#2. Perhaps you want to add some content. You can add single files
#   with "hugo new <SECTIONNAME>/<FILENAME>.<FORMAT>".
#3. Start the built-in live server via "hugo server".
#
#Visit https://gohugo.io/ for quickstart guide and full documentation.

# 目录结构
tree blog
#blog
#├── archetypes
#│   └── default.md
#├── config.toml
#├── content
#├── data
#├── layouts
#├── static
#└── themes
```
#### 安装主题
去 [themes.gohugo.io](http://themes.gohugo.io/) 选择喜欢的主题，下载到 themes 目录中，然后按照主题的说明对 config.toml 做相应配置（一般可以直接用主题里面的exampleSite的config.toml, 只需要做一些参数修改），我用的主题是 [vec](https://themes.gohugo.io/hugo-theme-vec/)

有个tutorial说到下载主题的方式，我选择的是第二种：
##### 1. 下载

-   可以直接  `clone`  到  `themes`  目录下，优点是如果对主题有调整需求可以同时提交到 git 控制中。
    
    ```
    git clone https://github.com/olOwOlo/hugo-theme-even themes/even
    ```
    
-   也可以添加到 git 的 submodule 中，优点是后面讲到用 travis 自动部署时比较方便。如果需要对主题做更改，最好 fork 主题再做改动。
    
    ```
    git submodule add https://themes.gohugo.io/hugo-theme-vec/ themes/vec
    ```
##### 2. 主题应用

复制 exampleSite 中 config.toml的
```
cp -r themes/vec/exampleSite/config.toml .
```
修改参数
```
vi config.toml
```
复制exampleSite中的文章
```
cp -r themes/vec/exampleSite/content content/
cp - themes/vec/exampleSite/static static/
```
新建文章
```
hugo new post/test.md
```
##### 3. 预览

执行命令，使用 Hugo 生成静态内容并在启动本地 HTTP Server。然后即可访问  [http://localhost](http://localhost/):1313/ 查看效果。

```
hugo server -D
#...
#Web Server is available at http://localhost:1313/ (bind address 127.0.0.1)
```
### Step 2: 部署Hugo Site 到 GitHub Pages
最终我们需要把博客部署到一个托管服务，免费稳定的 Github Pages 是个很好的选择。
#### 新建两个repository
在Github 上新建两个repository
- `<YOUR-PROJECT>` (e.g. `blog`) (e.g blog) （用于托管所有的Hugo 文件）
- `<USERNAME>`.github.io （用于展示Hugo Site, contain the fully rendered version of your Hugo website.）

以下步骤参考 [reference 1](https://segmentfault.com/a/1190000012975914) 中 **## 部署到 GitHub Pages**

1.  先把源码提交到 GitHub 的一个 repo (源码 repo --- blog)
    
    ```
    git add -A
    git commint -m "initial hugo files"
    git remote add origin https://github.com/<username>/blog
    git push -u origin master
    ```
2.  config.toml 的 `baseURL` 要设置成 `https://<username>.github.io` 

### Step 3: 利用Travis CI自动部署
利用 Travis CI自动部署，实现了blog repo有改动就会自动部署到 `<username>`.github.io

1. 生成 [Github Access Token](https://github.com/settings/tokens/new)，至少要有 public_repo 的权限。
![](https://image-static.segmentfault.com/327/147/3271470318-5a68537f7c98a)

2. 配置 Travis
去  [Travis CI](https://travis-ci.org/)  注册关联 Github 的账号，然后同步账户并激活 blog repo。
![](https://image-static.segmentfault.com/386/708/3867089403-5a6854a99ac7e)

接着进入 blog 的设置页面，选择自动部署触发条件，并把刚刚生成的 GitHub Access Token 添加到环境变量里。
![](https://image-static.segmentfault.com/482/028/482028402-5a6854b6312ef)
 
3. 在 blog repo 中添加 **.travis.yml**（放在blog 根目录）

```
sudo: false
language: go
git:
    depth: 1
install: go get -v github.com/gohugoio/hugo
script:
      hugo
deploy:
    provider: pages
    skip_cleanup: true
    github_token: $GITHUB_TOKEN
    on:
        branch: master
    local_dir: public
    repo: <username>/<username>.github.io
    fqdn: <custom-domain-if-needed>
    target_branch: master
    email: <github-email>
    name: <github-username>
```

**重点说下这个部分，tutorial里面的**

```
script: 
	 - hugo
```
**应该是：**
```
script:
      hugo
```

其余的参数配置可以根据自己情况调整，比如 **fqdn**， 可以填上个人域名，Travis CI 会自动生成 CNAME 文件，关于如何配置个人域名，可以参考[这篇文章](https://zhuanlan.zhihu.com/p/37752930) **# 配置个人域名**

最后，可以手动去 travis 触发一次 build 检查效果。如果设置了提交触发 build，之后每次 blog repo 有提交都会自动 build，不再需要关心 travis 状态。

### Step 4: 博客生成与管理
为了以后更加方便地生成管理博客，可以写一个script (e.g deploy.sh)，放在blog 根目录：

deploy.sh
```
#!/bin/sh

echo "Deleting old publication"
rm -rf public

# content update
hugo

echo "deploy" # 更新到 blog repo
git add -A
git commit -m "update"
git push -u origin master
```
以后的博客更新步骤：

1. 写博客 
```
hugo new post/<filename>.md # 新建博客
vi content/post/<filename>.md # 编辑博客
```

2. 部署到 blog repo
```
sudo sh deploy.sh
``` 

3. 如果Travis CI部署成功的话，它会自动检测到 blog repo的更新，会把Hugo内容自动部署到真正的网站 `<username>.github.io` 

这样以后只需要专心写blog啦！

最近会整理一些工作经验的文章，欢迎👏关注我的blog： http://jyhu.ml/

## Reference

喝水不忘挖井人，这里附上一些对我帮助很大的一些参考文章：

 1. https://segmentfault.com/a/1190000012975914
 2. https://zhuanlan.zhihu.com/p/37752930
 3. https://gohugo.io/hosting-and-deployment/hosting-on-github/ 
