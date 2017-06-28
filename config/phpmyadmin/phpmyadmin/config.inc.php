<?php

require('/etc/phpmyadmin/config.secret.inc.php');

/* Ensure we got the environment */
$vars = array(
    'PMA_ARBITRARY',
    'PMA_HOST',
    'PMA_HOSTS',
    'PMA_VERBOSE',
    'PMA_VERBOSES',
    'PMA_PORT',
    'PMA_PORTS',
    'PMA_USER',
    'PMA_PASSWORD',
    'PMA_ABSOLUTE_URI'
);
foreach ($vars as $var) {
    $env = getenv($var);
    if (!isset($_ENV[$var]) && $env !== false) {
        $_ENV[$var] = $env;
    }
}

/* Arbitrary server connection */
if (isset($_ENV['PMA_ARBITRARY']) && $_ENV['PMA_ARBITRARY'] === '1') {
    $cfg['AllowArbitraryServer'] = true;
}

/* Play nice behind reverse proxys */
if (isset($_ENV['PMA_ABSOLUTE_URI'])) {
    $cfg['PmaAbsoluteUri'] = trim($_ENV['PMA_ABSOLUTE_URI']);
}



/* Fallback to default linked */
$hosts = array('mariadb', 'web', 'localhost');

/* Set by environment */
if (!empty($_ENV['PMA_HOST'])) {
    $hosts = array($_ENV['PMA_HOST']);
    $verbose = array($_ENV['PMA_VERBOSE']);
    $ports = array($_ENV['PMA_PORT']);
} elseif (!empty($_ENV['PMA_HOSTS'])) {
    $hosts = explode(',', $_ENV['PMA_HOSTS']);
    $verbose = explode(',', $_ENV['PMA_VERBOSES']);
    $ports = explode(',', $_ENV['PMA_PORTS']);
}

/* Server settings */
for ($i = 1; isset($hosts[$i - 1]); $i++) {
    $cfg['Servers'][$i]['host'] = $hosts[$i - 1];
    if (isset($verbose[$i - 1])) {
        $cfg['Servers'][$i]['verbose'] = $verbose[$i - 1];
    }
    if (isset($ports[$i - 1])) {
        $cfg['Servers'][$i]['port'] = $ports[$i - 1];
    }
    if (isset($_ENV['PMA_USER'])) {
        $cfg['Servers'][$i]['auth_type'] = 'config';
        $cfg['Servers'][$i]['user'] = $_ENV['PMA_USER'];
        $cfg['Servers'][$i]['password'] = isset($_ENV['PMA_PASSWORD']) ? $_ENV['PMA_PASSWORD'] : '';
    } else {
        $cfg['Servers'][$i]['auth_type'] = 'cookie';
    }
    $cfg['Servers'][$i]['connect_type'] = 'tcp';
    $cfg['Servers'][$i]['compress'] = false;
    $cfg['Servers'][$i]['AllowNoPassword'] = true;
}
/* Figure out hosts */
$cfg['Servers'][80]['host'] = '192.168.99.100:3306'; //provide hostname and port if other than default
$cfg['Servers'][80]['user'] = 'whywebs';   //user name for your remote server
$cfg['Servers'][80]['password'] = 'whywebs';  //password
$cfg['Servers'][80]['auth_type'] = 'config';     // keep it as config
$cfg['Servers'][80]['connect_type'] = 'tcp';
$cfg['Servers'][80]['compress'] = false;
$cfg['Servers'][80]['AllowNoPassword'] = true;


/* Uploads setup */
$cfg['UploadDir'] = '';
$cfg['SaveDir'] = '';

/* Include User Defined Settings Hook */
if (file_exists('/etc/phpmyadmin/config.user.inc.php')) {
    include('/etc/phpmyadmin/config.user.inc.php');
}
