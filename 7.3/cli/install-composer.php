<?php

copy('https://getcomposer.org/installer', 'composer-setup.php');

if (hash_file('sha384', 'composer-setup.php') !== 'e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a') { 
    echo 'Installer corrupt', PHP_EOL; 
    unlink('composer-setup.php'); 
    exit(1);
} 

echo 'Installer verified', PHP_EOL;