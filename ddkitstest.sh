
#!/bin/sh

#  Script.sh
#
#
#
# This system built by Mutasem Elayyoub DDKits.com

php_lint_file()
{
  ./vendor/bin/phplint *deploy/ --exclude ddkits_files --exclude deploy/vendor --exclude vendor --exclude deploy/$WEBROOT/vendor
}

php_lint_file