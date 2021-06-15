# Objetos dentro de kubernetes

## Namespaces

## Nodes

## Pods

Minima unidad de gestión dentro de Kubernetes.

Podemos crear objetos de tipo Pod directamente en Kubernetes? SI

Lo vamos a hacer en algún momento? NO NUNCA EN LA VIDA

## PodTemplate

Podemos crear objetos de tipo Pod Template directamente en Kubernetes? SI

Lo vamos a hacer en algún momento? NO NUNCA EN LA VIDA

## Objetos generadores de PODs:

### Deployment
    Plantilla de Pod
    Número de replicas deseado para esa plantilla: 4 Pods
    
### StatefulSet
    Plantilla de Pod
    Número de replicas deseado para esa plantilla
    
### DaemonSet
    Plantilla de Pod
    Kubernetes en automático va a crear un pod para cada nodo del cluster basandose en la plantilla






# Preguntas: 

Entorno de producción:
    - Alta disponibilidad
    - Escalabilidad
    
Montaje de un cluster Activo/pasivo y Activo/activo

Contenedor (Pod) - nginx : 80  >>>> Kubernetes = docker > Red privada de Kubernetes/docker

## Alta disponibilidad: Cluster Activo/Pasivo
    No tengo 2 contenedores con el proceso en cuestión... Tengo 1 y lo tengo corriendo... 
        Si se cruje, lo mato y creo en ese momento otro contenedor y lo levanto
    
    Qué ha pasado cuando antes hemos borrado el POD de nginx y lo hemos a crear?
        Cambio de IP
    Qué IP le doy a mi cliente final? nombre dns >>> IP de quien? La de un balanceador de carga
    Aqui el balanceador cuandos sevidores de backend tenía: 1

## Alta disponibilidad+ Escalabilidad: Cluster Activo/Activo
    Voy a tener muchos contenedores (pod). Cada uno tendrá su propia IP
    Qué IP le doy a mi cliente final? nombre dns >>> IP de quien? La de un balanceador de carga
    Aqui el balanceador cuandos sevidores de backend tenía: muchos

# Esto en kubernetes se llama: SERVICE

# Objeto Service
    nombre dns >>> IP 
    Un balanceador de carga >>> Contenedores correspondientes en su puerto determinado
    
Un servicio es la manera de Exponer PUERTOS a otras personas/programas
SIEMPRE- SIEMPRE que necesite exponer o trabajar con un puerto voy a montar un servicio

Tipos de Servicio:
- ClusterIP         - Cuando SOLO queremos exponer el servicio Internamente <<<<<<< SIEMPRE - 1
- NodePort          - NUNCA
- LoadBalancer      - Cuando queramos exponer un servicio publicamente: 1 sola vez en todo el cluster


QUE PASA CUANDO QUEREMOS EXPONER UN SERVICIO FUERA DEL CLUSTER
Alternativas para conseguir esto:
1 - NodePort:
        Es un servicio ClusterIP, pero además:
        En cada nodo del cluster vamos a abrir un puerto (30000-327XX)
            que cuando se llama a ese puerto se redirige a la IP del servicio interno.
    
    Esto me resuelve acceder publicamente al servicio? SI
        Que IP le doy a mi cliente? La IP del nodo 1 o la IP del nodo 10?
        Necesito un balanceador EXTERNO al CLUSTER y un DNS EXTERNO AL CLUSTER. <<<<
                                ------------------          ------------------
    
2 - LoadBalancer
    Es un servicio de tipo NodePort integrado con un balanceador Externo automaticamente.
                                                     -------------------
    
3 - Trabajar con otro tipo de objeto que existe dentro de Kubernetes: INGRESS



## A nivel de implementación dentro de Kubernetes... que ha ocurrido cuando hemos dado de alta el servicio

SERVICIOS DE TIPO CLUSTER IP
    Agregar reglas a NetFilter. Qué es NetFilter: 
        Es el módulo que hay dentro del kernel de Linux que gestiona todos los paquetes de RED
        Iptables >>> NetFilter
    En todos y cada nodo del cluster, en sus reglas de netFilter se han añadido reglas para que :
        Cuando en esa máquina alguien llame a la IP XXXXXX del servicio
        Se reenvia a una de las IPs de los PODs que hay por detrás... A uno de ellos. < Algoritmo de balanceo
            Tenemos una cola? NO
    Quien se encarga de añadir esas reglas en cada HOST: KUBE-PROXY
    Balanceadores de carga: Proxy-reverso: Nginx, HA Proxy, Httpd     <<<<<     Modelo OSI . Capa de Aplicación 
        Implementan una cola que puedo gestionar
