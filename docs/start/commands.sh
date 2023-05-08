echo -e "DDkits
    List of commands after 'ddk <option>':
        docker  - Mac users can start their docker by using this command
        -h       - Show comand list
        who      - Show all details about your site
        go       - Start or check your DDKits working or not
        stop     - ACtivate default vm
        del      - Remove DDKits VM and go back to default
        clean    - Clean undefiend or unused Volumes and images
        rmn      - Clean <none> extra images and containers
        fix      - Fix DDKits containers in full for any problem
        start    - Start new your ddkits setup process 'this command must be in your project folder'
        prod     - Start production installation   // available with DDKits PRO only
            **************************
        // Database with DDkits
        db-import - Direct import DB into your Database
              ex. ddk db-import FILE_NAME.sql
        db-export - Direct export DB into your Database
              ex. ddk db-export FILE_NAME.sql
            **************************
        update  - Update your ddkits setup process 'this command must be in your project folder'
            **************************
        rebuild - Update your ddkits rebuild and build your project images and containers
                process 'this command must be in your project folder'
            **************************
        i       - Show all your docker images
        c       - Show all your docker containers
        r       - Docker run
        rm      - Remove your compose extra unused containers or containers with error
            **************************
        rm all  - Restore docker images and containers
                                'Important this command remove all your containers and images'
            **************************
        test  - CI/CD phplint checking all php files without vendors for a secure depoloyment
            **************************
    List of commands after 'ddk<option>':
        ri      remove an image from docker images
        rc      remove a continer from docker containers
            **************************
    Docker special commands
      new
           c       Create a container from an image ex. ( ddk new c ddkits/lamp:7)
           run     Docker exec the new container ex. ( ddk new run 5d05535340b8 /bin/bash )
    Containers DNS:
             **************************
    Kubernetes special commands
            kube   Start Kube and start the UI with Token

            **************************
    Linux/Ubuntu special commands
            ddkscan file-name.txt  - This will scan all the folder using find and list the suspected files into the file-name.txt
                                   - Grep and remove suspected @include files in php 
                                   - Find one line php files
                                   - Find random files names 
                                   - Grep location of suspected files
                                   
            deleteSuspectedPhp  file-name.txt   This will go through the file and delete all the listed items only 
            deleteSuspected   file-name.txt     This will go through the file and delete all the listed items, 
                               Root is must in this hook using chattr will unchattr the file in permission denied and folder, then delete, after that will lock the folder back again 
            ddkscanclean  file-name.txt   This do full clean up with scan and delete using the Root chattr for suspected folders to stop the malicious
            **************************

    Jenkins     http://jenkins.YOUR_DOMAIN.ddkits.site
    SOLR     http://solr.YOUR_DOMAIN.ddkits.site
    PhpMyAdmin     http://admin.YOUR_DOMAIN.ddkits.site
    MariaDB       ddkc-SiteName-db 
    PostgreSQL    ddkc-SiteName-pstgdb 
    Redis         ddkc-SiteName-cache

            **************************
    DDKits v4.353
        "
