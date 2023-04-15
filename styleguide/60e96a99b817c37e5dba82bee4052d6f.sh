#!/bin/bash
# /**
# * ApiDocPro UI render, for AsyncAPI, Swagger and OpenApi
# * by Sam Ayoub https://DDKits.com
# * https://github.com/ddkits
# * APIdocPro UI render based on React and Bootstrap, with the ability to contribute, modify and create different themes to be used.
# * Important: To use this code please leave the copyright in place
# * Reallexi LLC, https://reallexi.com
# */
export COPYRIGHTLEN=$(wc -l copyright.txt | cut -f1 -d ' ')
echo 'Directory path'
read SOURCE
echo 'Exclude Directory folders ex. node_modules '
read EXCLUDE

find $SOURCE -type d -name "$EXCLUDE" -prune -o -name "*.js" -print0 | sudo xargs -0 ./addcopyright.sh
for x in $*; do
  head -$COPYRIGHTLEN $x | diff copyright.txt - || ( 
    (
      cat copyright.txt
      echo
      cat $x
    ) > /tmp/file
    mv /tmp/file $x
  )
done
