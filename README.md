# Doker spip

Create container for [SPIP](http://www.spip.net) 

Container use debian:wheezy + SPIP 3.0

      $ sudo docker build -t dockers_spip-0.0.1 .
      $ sudo docker run --name spip-0.0.1 -v /etc/mysql -v /var/lib/mysql -v /var/www/spip -t -i dockers_spip-0.0.1 bash
      $ sudo docker run --name spipconfig --volumes-from spip-0.0.1 -t -i dockers_spip-0.0.1 bash

## Version 0.0.6

- Add volume

## Version 0.0.5

- Add entrypoint
- Add bash script 
- Add apache config

## Version 0.0.4

- Test Build

## Version 0.0.3

- Install SPIP

## Version 0.0.2

- Install Mysql

## Version 0.0.1

- Install Apache

## TODO

No correct ENTRYPOINT for Apache & Mysql