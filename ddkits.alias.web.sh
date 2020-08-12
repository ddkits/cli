#!/bin/sh

#  Script.sh
#
#
#
# This system built by Mutasem Elayyoub DDKits.com
# insert DDKits alias into any system command lines

# create get into ddkits container
alias ddkc-$DDKITSSITES-cache='docker exec -it '$DDKITSHOSTNAME'_ddkits_cache /bin/bash'
alias ddkc-$DDKITSSITES-jen='docker exec -it ddkits_jenkins /bin/bash'
alias ddkc-$DDKITSSITES-solr='docker exec -it '$DDKITSHOSTNAME'_ddkits_solr /bin/bash'
alias ddkc-$DDKITSSITES-admin='docker exec -it '$DDKITSHOSTNAME'_ddkits_admin /bin/bash'
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_web /bin/bash'
alias ddkc-$DDKITSSITES-db='docker exec -it '$DDKITSHOSTNAME'_ddkits_db /bin/bash'
alias ddkc-ddkits='docker exec -it ddkits /bin/bash'

# echo "alias ddkc-"$DDKITSSITES"-cache='docker exec -it "$DDKITSHOSTNAME"_ddkits_cache /bin/bash'" >> ~/.ddkits_alias_web
# echo "alias ddkc-"$DDKITSSITES"-jen='docker exec -it ddkits_jenkins /bin/bash'" >> ~/.ddkits_alias_web
# echo "alias ddkc-"$DDKITSSITES"-solr='docker exec -it "$DDKITSHOSTNAME"_ddkits_solr /bin/bash'" >> ~/.ddkits_alias_web
# echo "alias ddkc-"$DDKITSSITES"-admin='docker exec -it "$DDKITSHOSTNAME"_ddkits_admin /bin/bash'" >> ~/.ddkits_alias_web

# New entry check to stay out of duplications
entry1="alias ddkc-"$DDKITSSITES"-cache='docker exec -it "$DDKITSHOSTNAME"_ddkits_cache /bin/bash'"
entry2="alias ddkc-"$DDKITSSITES"-jen='docker exec -it "$DDKITSHOSTNAME"_ddkits_jenkins /bin/bash'"
entry3="alias ddkc-"$DDKITSSITES"-solr='docker exec -it "$DDKITSHOSTNAME"_ddkits_solr /bin/bash'"
entry4="alias ddkc-"$DDKITSSITES"-admin='docker exec -it "$DDKITSHOSTNAME"_ddkits_admin /bin/bash'"
entry5="alias ddkc-"$DDKITSSITES"='docker exec -it "$DDKITSHOSTNAME"_ddkits_web /bin/bash'"
entry6="alias ddkc-"$DDKITSSITES"-db='docker exec -it "$DDKITSHOSTNAME"_ddkits_db /bin/bash'"
entry=($entry1 $entry2 $entry3 $entry4 $entry5 $entry6)
matches="$(grep -n ${DDKITSSITES} ~/.ddkits_alias_web | cut -f1 -d:)"

if [ ! -z "$matches" ]; then
  echo "Updating existing entry."

  # iterate over the line numbers on which matches were found
  while read -r line_number; do
    # replace the text of each line with the desired entry
    echo ${SUDOPASS} | sudo -S sed -i '' "/${line_number}/d" ~/.ddkits_alias_web
  done <<<"$matches"
fi
echo "Adding new entry."
  echo "${entry1}" | sudo tee -a ~/.ddkits_alias_web >/dev/null
  echo "${entry2}" | sudo tee -a ~/.ddkits_alias_web >/dev/null
  echo "${entry3}" | sudo tee -a ~/.ddkits_alias_web >/dev/null
  echo "${entry4}" | sudo tee -a ~/.ddkits_alias_web >/dev/null
  echo "alias ddkc-ddkits='docker exec -it ddkits /bin/bash'" | sudo tee -a ~/.ddkits_alias_web >/dev/null
