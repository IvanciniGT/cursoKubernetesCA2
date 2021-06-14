# minikube

Herramienta que instala un cluster de kubernetes de juguete-juguete perfecto para aprender y entornos de desarrollo.
Ya lleva instalado de antemano un monton de cosas que nosotros no tenemos a priori en un cluster real.


# Kubernetes

Orquestador de contenedores, especialmente indicado para entornos de PRODUCCION.
Gestión automatizada de la Alta disponibilidad y la escalabilidad de mis apps...

# Contenedores

Entorno aislado para la ejcución de Procesos dentro de un SO Linux.
    Filesystem
    Conf. red
    Limitación de acceso a recurcos hardware
    Otras configuraciones:
        Primer proceso / Proceso principal que va a estar en ejecución dentro del contenedor.

Un contenedor lo creamos a partir de una imagen de contenedor, que consiste en:
    - Un archivo comprimido (ZIP) una estructura de archivos y carpetas dentro... era similar a la de una distro de Linux.
    - Configuración, aceca de cómo se utilizaba esa imágn de contenedor:
        - Volumenes de datos podíamos montar de forma recomendada
        - Información a priori de los puertos que se usan dentro del contenedor
        - Variables de entorno que se usan por los procesos del contenedor. Con valores por defecto.
    - Documentación 

Un buen sitio es Docker Hub... Es un repo oficial de imagenes de contenedor DOCKER.

# Instalación

Kubernetes es un orquestador de contenedores... pero necesita de un GESTOR DE CONTENEDORES.

Docker engine:
- Servidor  - dockerd
    - DockerD    --- Gestor de contenedores basado en ContainerD 
        - Crear imágenes de contenedor
        - Descarga contra el repo de docker (que requiera login)
    -> ContainerD --- Demonio de gestión de contendores:            ----- CRIO (alternativa a ContainerD)
        - Crear un contenedor, pararlo, arrancarlo, ver sus logs....
        - Gestión de imágenes de contenedor: Descargar, borrar, almacenar, listar
    - RunC --- Ejecutor de un contenedor concreto
- Cliente   - docker

systemd <<< systemctl



## Qué es una de las primeras cosas que hace docker cuando lo instalamos:

Montar un interfaz de red privado virtual dentro del host

## Que es un pod:
Unidad mínima de gestión dentro de Kubernetes. Conjunto de contenedores que comparten:
1º Están en la misma máquina
2º Misma IP
3º Comparten escalado

# Kubernetes está formado por varios programs, que trabajn de forma coordinada.

La mayor parte de esos programas se instalan mediante contenedores dentro del propio cluster de Kubernetes.

# Software Kubernetes:

kubeadm < Gestionar un cluster: Alta, borrado, añadir nodos nuevos a un cluster. Instalación sobre el HIERRO
    En todos los nodos
kubelet < Demonio de kubernetes ~ dockerd. Este es el programa que llama a dockerd/containerD/CRIO. Instalación sobre el HIERRO
    En todos los nodos
kubectl < Cliente de kubernetes ~ docker
    Solo donde queramos conectarnos al cluster
    ------------ CONTENEDORES: Plano de control de Kubernetes
    apiserver < Dentro de un contenedor (Es quien recibe realmente todas las ordenes de los clientes)
    etcd      < Una base de datos clave-valor (similar a lo que sería un mongodb)
    scheduler < Determinar en que nodo (máquina) se va a instalar un determinado POD
    kubeproxy <  Gestor de la red virtual que vamos a montar entre los nodos del cluster. En cada nodo.
    controller-manager < De todo... todo lo demás
    coreDNS   < Servidor de DNS interno del cluster
    -------------------

CLIENTE    |   MAESTRO(s)     |      NODO (worker)
kubectl  >>>>> apiserver  >>>>>>> kubelet   >>>> dockerd   >>> containerD  >>>> runC


# Objetos en Kubernetes

## Pod

Conjunto de contenedores...

## Namespace - Espacio de nombres

Segmentación de un cluster, que agrupa de manera lógica objetos dentro de kubernetes. Ejemplos de namespaces:
    - Producción
    - Desarrollo
    - Pruebas
    - ClienteA
    - Ivan
    - default
    - kube-system: namespace para los pods de su plano de control
    
## Node

Representa un nodo dentro de kubernetes
