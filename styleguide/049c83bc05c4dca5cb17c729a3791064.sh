#!/bin/sh

#  Script.sh
# built by Sam Ayoub https://ddkits.com

php_lint_file() {
  ./vendor/bin/phplint -vv *deploy/ \
    --exclude ddkits_files \
    --exclude deploy/vendor \
    --exclude */vendor
}
if test -f "./vendor/bin/phplint"; then
  echo 'PHP ready to test'
else
  composer install
fi
php_lint_file
