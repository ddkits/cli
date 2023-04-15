DDKits is now on composer. Package management is clearly the right route forward for PHP Languages such as Ruby have shown how incredibly easy it is to use packages within projects so common problems can be solved once, and you can stop wasting time as a developer by constantly reinventing the wheel.





```shell
composer create-project --keep-vcs ddkits/cli PROJECT_FOLDER
```

Github:
```shell
git clone https://github.com/ddkits/cli.git 
```

### Before starting
- Docker, Docker Compose and Docker Machine must be installed on the system before using DDKits. (To save your self time, try to use Docker Toolbox)

### Virtual Box
VirtualBox is a general-purpose full virtualizer for x86 hardware, targeted at server, desktop and embedded use. 
For a thorough introduction to virtualization and VirtualBox, please refer to the online version of the VirtualBox User Manual's first chapter.
- - VirtualBox 6.1.16 (this version is the best version to use with docker-machine as for April/2022 with no issues in vboxnet creation)
 - Windows hosts
 - OS X hosts
 - Solaris hosts
- - Linux Hosts:
 - Ubuntu 19.10 / 20.04 / 20.10 / 21.04
 - Ubuntu 18.04 / 18.10 / 19.04
 - Ubuntu 16.04
 - Ubuntu 14.04 / 14.10 / 15.04
 - Debian 10
 - Debian 9
 - Debian 8
 - All distributions
 - Extension Pack
 - Sources
- MD5 checksums, SHA256 checksums
- Windows hosts - for technical reasons this package will be made available later
 - OS X hosts
- Linux distributions
 - Solaris hosts
 
### Docker
 Is the world’s leading software container platform. Developers use Docker to eliminate “works on my machine” problems when collaborating on code with co-workers. Operators use Docker to run and manage apps side-by-side in isolated containers to get better compute density. Enterprises use Docker to build agile software delivery pipelines to ship new features faster, more securely and with confidence for both Linux, Windows Server, and Linux-on-mainframe apps.
 
#### Docker Composer
 Is a tool for defining and running complex applications with Docker. With compose, you define a multi-container application in a single file, then spin your application up in a single command which does everything that needs to be done to get it running.

#### Docker Machine
 Is a Docker tool which makes it really easy to create Docker hosts on your computer, on cloud providers and inside your own data center. It creates servers, installs Docker on them, then configures the Docker client to talk to them.
 
#### Docker Toolbox
 Is a legacy installer for Mac and Windows users. It uses Oracle VirtualBox for virtualization. For Macs running OS X El Capitan 10.11 and newer macOS releases, Docker for Mac is the better solution. For Windows 10 systems that support Microsoft Hyper-V (Professional, Enterprise and Education), Docker for Windows is the better solution.


* In case of other issue please contact us or report an issue in DDKits github


## getting started
Using Composer:
===============

- 1- Open terminal:

- 2- Create a project using Composer create-project

composer create-project ddkits/cli <folder\_name>

- 3- DDKits will automatically install and clone the base CLI into your home folder ~/.

- 4- DDkits will run install as one of the composer automatic installation

Localhost or Virtual host 

- 4.1- if you need localhost then no need to worry about Virtual Host 

- 4.2- If you are using different tools and containers that using default localhost, preferred to use Virtual host option

- 5- Check the command "ddk" after installing and proxy DDkits is running

Using github:
=============

- 1- Open terminal and clone DDKits from github as below:
```shell
git clone [https://github.com/ddkits/cli.git](https://github.com/ddkits/cli.git)  PATH/TO/FOLDER
```
- 2- Run DDKits alias file in terminal, make sure you are in the same folder that you cloned the reposatory in. This step to add DDKits command " ddk " into your terminal:
```shell
cd  PATH/TO/FOLDER && source ddkits.alias.sh
```
- 3- After it finish, check your ddk by running the main command as below:
```shell
ddk
```
Using the zip file:
===================

- 1- extract the content of the file into the folder that you want your site to load from:

- 2- Run DDKits alias file in terminal \*\*make sure you are in the same folder that you cloned the reposatory in .\*\*, this step to add DDKits command " ddk " into your terminal:
```shell
source ddkits.alias.sh
```
- 3- After it finish, check your ddk by running the main command as below:
```shell
ddk
```
Next:
=====

Check your Docker, Docker-compose, docker-machine and DDKits installations by 

\-In your terminal then: 
```shell
$  docker -v && docker-compose --version && docker-machine -version  && ddk
```
[Before DDKits Installation](/file/142)
---------------------------------------

![Before DDKits Installation](https://ddkits.com/sites/files/Screen%20Shot%202017-08-17%20at%201.53.44%20PM.png "Before DDKits Installation")

[Before start](/file/143)
-------------------------

![Before start](https://ddkits.com/sites/files/Screen%20Shot%202017-08-17%20at%201.53.39%20PM.png "Before start")

\-If DDKits  "ddk not found ", go to any DDKits project then:
```shell
$ . ddkits.alias.sh
$ 
$ OR
$ 
$ ./ddkits.alias.sh
$ 
$ OR
$ 
$ . ddkits.alias.sh
```

\-then run again the main command:

$ ddk

\- DDKits is a Unix base software which means it can be controled 100%.

To start your DDKits new website you need to begin your software first and install DDKits main containers first by 

ddk install

![](http://ddkits.com/sites/default/files/Screen%20Shot%202017-07-03%20at%209.27.13%20AM.png)

[DDKits install](/file/36)
--------------------------

![DDKits install](https://ddkits.com/sites/files/Screen%20Shot%202017-07-03%20at%209.25.41%20AM.png "DDKits install")

\- then 
```shell
ddk start
```
\- Drupal version only start it with composer by using the command below
```shell
ddk start com
```

