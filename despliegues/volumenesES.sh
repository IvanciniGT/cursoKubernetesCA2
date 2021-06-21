#!/bin/bash
kubectl delete pv master-1
kubectl delete pv master-2
kubectl delete pv master-3

../instalacion/volumen.sh -n master-1 -c redundante -s 5Gi -p /home/ubuntu/environment/datos/es/master1
../instalacion/volumen.sh -n master-2 -c redundante -s 5Gi -p /home/ubuntu/environment/datos/es/master2
../instalacion/volumen.sh -n master-3 -c redundante -s 5Gi -p /home/ubuntu/environment/datos/es/master3
