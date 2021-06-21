#!/bin/bash

../instalacion/volumen.sh -n master-1 -c redundante -s 5Gi -p /home/ubuntu/enviroment/datos/es/master1
../instalacion/volumen.sh -n master-2 -c redundante -s 5Gi -p /home/ubuntu/enviroment/datos/es/master2
../instalacion/volumen.sh -n master-3 -c redundante -s 5Gi -p /home/ubuntu/enviroment/datos/es/master3
