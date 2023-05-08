<a href="https://www.youtube-nocookie.com/embed/hAQI9eYQugg?rel=0&amp;wmode=opaque">Embedded video for Jenkins installation</a>

DDKits Jenkins installation
===========================

Jenkins is an open source automation server written in Java. Jenkins helps to automate the non-human part of software development process, with continuous integration and facilitating technical aspects of continuous delivery. It is a server-based system that runs in servlet containers such as Apache Tomcat. It supports version control tools, including AccuRev, CVS, Subversion, Git, Mercurial, Perforce, ClearCase and RTC, and can execute Apache Ant, Apache Maven and sbt based projects as well as arbitrary shell scripts and Windows batch commands.

[Joomla website »](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0ahUKEwjc6_H_je7VAhXph1QKHdthBcMQFggoMAA&url=https%3A%2F%2Fjenkins.io%2F&usg=AFQjCNHwOJU-lmtmG89TB7bVdt1VJu8R8A)  

Tags:

Windows Linux Content Management Popular  AD CD

* * *

1- Make sure DDKits software is installed

ddk install

2- Start your environment installation

ddk start

3- Fill all information needed as the image below

[DDKits Jenkins installation](/file/144)
----------------------------------------

![DDKits Jenkins installation](https://ddkits.com/sites/files/Screen%20Shot%202017-08-23%20at%2011.37.00%20AM.png "DDKits Jenkins installation")

[DDKits Jenkins installation](/file/145)
----------------------------------------

![DDKits Jenkins installation](https://ddkits.com/sites/files/Screen%20Shot%202017-08-23%20at%2011.37.15%20AM.png "DDKits Jenkins installation")

4- Open any browser and try to opend the domain that you picked for your environment (our example here we picked jen.dev)

![](https://ddkits.com/sites/default/files/Screen%20Shot%202017-07-03%20at%206.25.59%20PM.png)

[DDKits Jenkins installation](/file/148)
----------------------------------------

![DDKits Jenkins installation](https://ddkits.com/sites/files/Screen%20Shot%202017-08-23%20at%2011.40.40%20AM.png "DDKits Jenkins installation")

5.1- To get the passcode to unlock Jenkins, open the terminal and use the command below  :

ddkc-DOMAIN-pass

[DDKits Jenkins installation](/file/153)
----------------------------------------

![DDKits Jenkins installation](https://ddkits.com/sites/files/Screen%20Shot%202017-08-23%20at%2012.02.49%20PM.png "DDKits Jenkins installation")

or

5.2- Open Jenkins folder (jenkins-deploy) in your DDKits installation folder, and go to secrets folder, then open the intialAdminPassword file and copy the passcode from it.

[DDKits Jenkins installation](/file/149)
----------------------------------------

![DDKits Jenkins installation](https://ddkits.com/sites/files/Screen%20Shot%202017-08-23%20at%2012.01.25%20PM.png "DDKits Jenkins installation")

\*\*- In case of an error when you open the domain as below:

[DDKits Jenkins installation](/file/146)
----------------------------------------

![DDKits Jenkins installation](https://ddkits.com/sites/files/Screen%20Shot%202017-08-23%20at%2011.37.37%20AM.png "DDKits Jenkins installation")

please give jenkins more time if it didn't work after 2 mins then do the command below within the root folder of Jenkins DDKits installed in:

ddk rebuild

[DDKits Jenkins installation](/file/147)
----------------------------------------

![DDKits Jenkins installation](https://ddkits.com/sites/files/Screen%20Shot%202017-08-23%20at%2011.37.52%20AM.png "DDKits Jenkins installation")

Joomla home directory :

jenkins-deploy/

*   [Add child page](/node/add/book?parent=693)
*   [Printer-friendly version](/book/export/html/36 "Show a printer-friendly version of this book page and its sub-pages.")
*   10 reads

ddkits-admin

Add new comment
---------------

Your name [ddkits-admin](/users/ddkits-admin "View user profile.")

Subject 

Comment \*

[More information about text formats](/filter/tips)

Text format Filtered HTMLFull HTMLPlain textPHP code

### Filtered HTML

*   Web page addresses and e-mail addresses turn into links automatically.
*   Allowed HTML tags: <a> <em> <strong> <cite> <blockquote> <code> <ul> <ol> <li> <dl> <dt> <dd>
*   Lines and paragraphs break automatically.

### Full HTML

*   Web page addresses and e-mail addresses turn into links automatically.
*   Lines and paragraphs break automatically.

### Plain text

*   No HTML tags allowed.
*   Web page addresses and e-mail addresses turn into links automatically.
*   Lines and paragraphs break automatically.

### PHP code

*   You may post PHP code. You should include <?php ?> tags.