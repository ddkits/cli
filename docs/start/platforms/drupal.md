DDKits Drupal 8 installation
============================

Drupal is software that allows an individual or a community of users to easily publish, manage and organize a great variety of content on a website. Tens of thousands of people and organizations have used Drupal to set up scores of different kinds of web sites.

[Drupal website »](https://drupal.org/)  

Tags:

Linux Content Management Popular

* * *

1- Make sure DDKits software is installed

ddk install

2- Start your environment installation

ddk start

3- Fill all information needed as the image below

![](https://ddkits.com/sites/default/files/Screen%20Shot%202017-07-05%20at%203.26.28%20PM.png)

4- Open any browser and try to opend the domain that you picked for your environment (our example here we picked drupal-8.dev)

![](https://ddkits.com/sites/default/files/Screen%20Shot%202017-07-05%20at%203.36.49%20PM.png)

DDKits Drupal 8  Drush
======================

\*\*- Without Drush, Drupal is hard to control, that's why DDKits allowing you to use drush from your localhost same as you are hosting your Drupal on your local folder without the need to create drush alias:

**ddkd-DOMAIN**

ex. 

**ddkd-drupal-8.dev**

![](https://ddkits.com/sites/default/files/Screen%20Shot%202017-07-05%20at%201.53.26%20PM.png)

To clear Drupal Cache:

drush without DDKits ==> drush cr or drush cache rebuild

drush with DDKIts ==> ddkd DOMAIN cr or ddkd DOMAIN cache rebuild

ex. to clear the cahce of a DDKits project domain drupal-8.dev

**ddkd-drupal-8.dev cr**

![](https://ddkits.com/sites/default/files/Screen%20Shot%202017-07-05%20at%203.40.52%20PM.png)

![](https://ddkits.com/sites/default/files/Screen%20Shot%202017-07-05%20at%204.22.08%20PM.png)

![](https://ddkits.com/sites/default/files/Screen%20Shot%202017-07-05%20at%204.23.52%20PM.png)

[DDKts Drupal 8 Installation](/file/102)
----------------------------------------

![DDKts Drupal 8 Installation](https://ddkits.com/sites/files/Screen%20Shot%202017-07-13%20at%207.07.34%20PM.png "DDKts Drupal 8 Installation")

Drupal 8 home directory :

deploy/public

*   [Add child page](/node/add/book?parent=640)
*   [Printer-friendly version](/book/export/html/12 "Show a printer-friendly version of this book page and its sub-pages.")
*   [Add new comment](/content/drupal-8-installation#comment-form "Share your thoughts and opinions related to this posting.")
*   14 reads

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