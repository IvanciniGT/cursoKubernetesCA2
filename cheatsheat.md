# Kubectl

Forma básica de invocar kubectl:
    $ kubectl verbo tipo-de-objeto argumentos-extra
                V
                - get
                - describe
                - create

# General

## Crear/modificar objetos dentro de Kubernetes    
    $ kubectl apply -f FICHERO.yaml -n NAMESPACE
    

# Pods

## Ver los pods de un namespace
    $ kubectl get pods --namespace XXXXXXX
    $ kubectl get pods -n XXXXXXX
    $ kubectl get pods --all-namespaces

# Nodo

## Ver los nodos que tengo
    $ kubectl get nodes
    
# Namespaces

## Ver que namespaces hay
    $ kubectl get namespaces

## Crear un namespace
    $ kubectl create namespace NOMBRE-NAMESPACE

## Borrar un namespace
    $ kubectl delete namespace NOMBRE-NAMESPACE
    