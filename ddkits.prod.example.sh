#!/bin/sh

#  Script.sh
#
#
#
# This system built by Mutasem Elayyoub DDKits.com

# insert DDKits alias into anyh system command lines
DDKITSFL=$(pwd)
DDKITSIP='127.0.0.1'
clear
cat "$DDKITSFL/ddkits-files/ddkits/logo.txt"

echo -e "
  Welcome to DDKits production Version
  " 

    # ---------------------------------------------------------------------------------------------------
    # ------------------------------------    Start from here    ----------------------------------------
    # ---------------------------------------------------------------------------------------------------

    # echo -e 'enter your E-mail address that you want to use in your website as an admin: '
    MAIL_ADDRESS='melayyoub@outlook.com'

    # echo -e 'enter your Domain Name: '
    DDKITSSITES='prod.dev'

    # echo -e 'enter your Sudo/Root Password if you have it:'
    SUDOPASS=''

    # echo -e 'enter your MYSQL ROOT USER: '
    MYSQL_USER='ddk'

    # echo -e 'enter your MYSQL ROOT USER Password: '
    MYSQL_ROOT_PASSWORD='ddk'

    # echo -e 'enter your MYSQL DataBase: '
    MYSQL_DATABASE='ddk'


    # PICK WHICH PLATFORM
    # 
    # Setup options Please make sure of all options before publish pick list, you are allowed to use only one platform for each folder. 
    # If you picked different platform ((("""""please make sure to comment all other platforms, by adding ' # ' before the source""")))
    # 

    #    "If you want to setup this platform please UNCOMMENT or remove '#' before source under this line only Drupal 7"
          # source $DDKITSFL/ddkits-files/ddkits/ddk-drupal7.sh
              
    #    "If you want to setup this platform please UNCOMMENT or remove '#' before source under this line only Drupal 8"  
          # source $DDKITSFL/ddkits-files/ddkits/ddk-drupal8.sh

    #    "If you want to setup this platform please UNCOMMENT or remove '#' before source under this line only Wordpress"
          # source $DDKITSFL/ddkits-files/ddkits/ddk-wordpress.sh

    #    "If you want to setup this platform please UNCOMMENT or remove '#' before source under this line only Joomla")
          # source $DDKITSFL/ddkits-files/ddkits/ddk-joomla.sh

    #    "If you want to setup this platform please UNCOMMENT or remove '#' before source under this line only Laravel")
           source $DDKITSFL/ddkits-files/ddkits/ddk-laravel.sh

    #    "If you want to setup this platform please UNCOMMENT or remove '#' before source under this line only LAMP/PHP5")
          # source $DDKITSFL/ddkits-files/ddkits/ddk-php5.sh

    #    "If you want to setup this platform please UNCOMMENT or remove '#' before source under this line only LAMP/PHP7")
          # source $DDKITSFL/ddkits-files/ddkits/ddk-php7.sh

    #    "If you want to setup this platform please UNCOMMENT or remove '#' before source under this line only Umbraco")
          # source $DDKITSFL/ddkits-files/ddkits/ddk-umbraco.sh

    #    "If you want to setup this platform please UNCOMMENT or remove '#' before source under this line only Magento")
          # source $DDKITSFL/ddkits-files/ddkits/ddk-magento.sh

    #    "If you want to setup this platform please UNCOMMENT or remove '#' before source under this line only DreamFactory")
          # source $DDKITSFL/ddkits-files/ddkits/ddk-dreamfactory.sh

    #    "If you want to setup this platform please UNCOMMENT or remove '#' before source under this line only Contao")
          # source $DDKITSFL/ddkits-files/ddkits/ddk-contao.sh

    #    "If you want to setup this platform please UNCOMMENT or remove '#' before source under this line only Elgg")
          # source $DDKITSFL/ddkits-files/ddkits/ddk-elgg.sh

    #    "If you want to setup this platform please UNCOMMENT or remove '#' before source under this line only Silverstripe")
          # source $DDKITSFL/ddkits-files/ddkits/ddk-silverstripe.sh

    #    "If you want to setup this platform please UNCOMMENT or remove '#' before source under this line only Cloud")
          # source $DDKITSFL/ddkits-files/ddkits/ddk-cloud.sh

    #    "If you want to setup this platform please UNCOMMENT or remove '#' before source under this line only ZenCart")
          # source $DDKITSFL/ddkits-files/ddkits/ddk-zencart.sh

    #    "If you want to setup this platform please UNCOMMENT or remove '#' before source under this line only Symfony")
          # source $DDKITSFL/ddkits-files/ddkits/ddk-symfony.sh

    #    "If you want to setup this platform please UNCOMMENT or remove '#' before source under this line only Expression Engine")
          # source $DDKITSFL/ddkits-files/ddkits/ddk-eengine.sh

    #    "If you want to setup this platform please UNCOMMENT or remove '#' before source under this line only Zend")
          # source $DDKITSFL/ddkits-files/ddkits/ddk-zend.sh

    #    "If you want to setup this platform please UNCOMMENT or remove '#' before source under this line only Jenkins")
          # JENKINS_ONLY='true'
          # source $DDKITSFL/ddkits-files/ddkits/ddk-jenkins.sh


    # ---------------------------------------------------------------------------------------------------
    # ------------------------------------        End here       ----------------------------------------
    # ---------------------------------------------------------------------------------------------------


    #  do not change anything below this line
    # ---------------------------------------------------------------------------------------------------


      #  delete ddkits conf file for the custom site if available
      if [ -f "ddkits-files/ddkits/sites/ddkitscust.conf" ]
        then 
        rm ddkits-files/ddkits/sites/ddkitscust.conf
      fi

    #  delete ddkits conf file for the custom site if available
    if [ -f "ddkits-files/ddkits/sites/ddkitscust.conf" ]
      then 
      rm ddkits-files/ddkits/sites/ddkitscust.conf
    fi

    cat "$DDKITSFL/ddkits-files/ddkits/logo.txt"

    JENKINS_ONLY='false'
    JENKINS_ANSWER='n'
    SOLR_ANSWER='n'

    cat "$DDKITSFL/ddkits-files/ddkits/logo.txt"

    JENKINS_ONLY='false'
    DDKITSHOSTNAME=${DDKITSSITES//./_}

    export DDKITSFL=$DDKITSFL
    export DDKITSIP=$DDKITSIP 
    export JENKINS_ANSWER=${JENKINS_ANSWER}
    export JENKINS_ONLY=${JENKINS_ONLY}
    export JENKINS_ANSWER=${JENKINS_ANSWER}
    export SUDOPASS=${SUDOPASS}
    export MAIL_ADDRESS=${MAIL_ADDRESS}
    export DDKITSSITES=${DDKITSSITES}
    export DDKITSIP=${DDKITSIP}
    export MYSQL_USER=${MYSQL_USER}
    export MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
    export MYSQL_DATABASE=${MYSQL_DATABASE}
    export MYSQL_PASSWORD=${MYSQL_ROOT_PASSWORD}
    export DDKITSWEBPORT=${DDKITSWEBPORT}
    export DDKITSHOSTNAME=${DDKITSHOSTNAME}
    export MYSQL_PASSWORD=${MYSQL_ROOT_PASSWORD}


    echo -e '
    #!/bin/sh

    #  Script.sh
    #
    #
    #  Created by mutasem elayyoub ddkits.com
    #

    export DDKITSFL="${DDKITSFL}"
    export DDKITSIP="${DDKITSIP}" 
    export JENKINS_ANSWER="${JENKINS_ANSWER}"
    export JENKINS_ONLY="${JENKINS_ONLY}"
    export JENKINS_ANSWER="${JENKINS_ANSWER}"
    export SUDOPASS="${SUDOPASS}"
    export MAIL_ADDRESS="${MAIL_ADDRESS}"
    export DDKITSSITES="${DDKITSSITES}"
    export DDKITSIP="${DDKITSIP}"
    export MYSQL_USER="${MYSQL_USER}"
    export MYSQL_ROOT_PASSWORD="${MYSQL_ROOT_PASSWORD}"
    export MYSQL_DATABASE="${MYSQL_DATABASE}"
    export MYSQL_PASSWORD="${MYSQL_ROOT_PASSWORD}"
    export DDKITSWEBPORT="${DDKITSWEBPORT}"
    export DDKITSHOSTNAME="${DDKITSHOSTNAME}"
    export MYSQL_PASSWORD="${MYSQL_ROOT_PASSWORD}"' > $DDKITSFL/ddkits-files/ddkitsInfo.prod.sh
