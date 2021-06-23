Provisionador NFS
---------------------
Aplicación que provisiona Volumenes (sacados de un servidor NFS) a petición.
A petición significa:
    Cuando dentro del cluster de Kubernetes se realiza una pvc

Si estamos montando una aplicación, que va a ser eso dentro de Kubernetes?
    Container < Pod < Template < Deployment/StatefulSet

Ese programa que vamos a montar es lo que denominamos un PROVISIONADOR
Ese programa va a estar ejecutándose como un demonio.
Ese programa va a estar monitorizando cuando se crea una nueva peticion de volumen.
Que va a necesitar este programa?
    UN USUARIO PROPIO PARA ÉL <<< ServiceAccount <> RoleBinding <> Role (Definición de Permisos)
    
Una definición de permisos dentro de Kubernetes: 
    - Tipo de Objeto - Operaciones que puedo hacer sobre ese tipo de objetos
    - pv - create, get, delete
    - pvc - get, watch, update
    
Usuario crea una pvc >>> Auto: Provisioner crear un pv
Usuario borra la pvc >>> Auto: Provisioner mantener/borrar el pv    <<<< Retain Policy

-------------------------
Montar una web -CRM
    Apache -< php (wordpress)
                    VVV
                BBDD adicional  
Es directorio donde se guarden los archivos que subo a mi web (imagen, pdf)
que necesito en kubernetes para ese directorio? Volumen Persistente

Deployment / StatefulSet?
    SERVICIO > Wordpress 1
                    Guardo una imagen en el disco duro <<< VOLUMEN para todos los WP
               Wordpress 2
                    
HELM >>>> storageclass capacity >>> Crea el pvc (En medio del YAML que veiamos con el comando helm template)
Que pasaria si en un momento desinstalo el chart y mas adelante lo vuelvo a instalar?

----------------------------------------------------------------------------------------------------------------
AFINIDADES
----------------------------------------------------------------------------------------------------------------

Cluster Kubernetes
    Nodo 1
    Nodo 2
    Nodo 3
    ....
    Nodo N
    
Deployment <<< Plantilla de Pods >>> Pods ¿Donde van esos pods?
    Lo decide el scheduler

La decisión que tome el scheduler, me va bien a mi?
    Puede ser que si... puede ser que no.

En que basa el scheduler sus decisiones: 
    - Recursos que tiene comprometidos de antemano.

Ese es el único criterio interesante?
En que casos no?
    - 2 wordpress que estén en 2 nodos diferentes. Por HA.
        ANTIAFINIDAD A NIVEL DE POD CON TOPOLOGIA DEL NODO
    - Cosas que quiero que corran dentro del mismo nodo ...
        AFINIDAD A NIVEL DE POD CON TOPOLOGIA DEL NODO
        SIDECARS ???? Se controla a nivel de POD
    - Ubicaciones geograficas. Quizás tengo un cluster muy grande... y tiene maquinas (nodos) en ubicaciones diferentes
        AFINIDAD A NIVEL DE NODO
    - Limitar que en ciertos nodos no se instalen segun que cosas (maestros)
        AFINIDAD A NIVEL DE NODO que no tenga una label
    - App que usa GPUs. Todos los nodos van a tener GPUs?
        AFINIDAD A NIVEL DE NODO
    - Nodos con diferentes características: 
        - Un ancho de banda especial
        - Arquitecturas diferentes
            - Raspberry pi <<< WEBs Wordpress 

La idea es tener un sistema flexible.
Hemos usado algo en Kubernetes que nos de flexibilidad a la hora de establecer vínculos? Labels

Nosotros podemos etiquetar Nodos con LABELS e indicarle a nuestro scheduler que tenga en cuenta las etiquetas

A nivel del POD, PODTEMPLATE:
        
# Como etiquetas nodo:
$ kubectl label nodes ip-172-31-11-196 zona=EUROPA

## Etiquetas genéricas:
    beta.kubernetes.io/arch=amd64
    beta.kubernetes.io/os=linux
    kubernetes.io/arch=amd64
    kubernetes.io/hostname=ip-172-31-11-196
    kubernetes.io/os=linux
    node-role.kubernetes.io/control-plane=
    node-role.kubernetes.io/master=
    node.kubernetes.io/exclude-from-external-load-balancers=
    
    
KubeSchedulerConfiguration < Permite establecer reglas de affinity para Admins

------------------------------------------------------------------------------------
                NS: DESA       NS: PROD
Nodo 1          
    Mariadb       x
    Mariadb                         x
Nodo 2
    WAS                             x
Nodo 3
    WAS                             x
    WAS           x
Nodo 4
    Tomcat        x
    Programa 
      piraton     x
    
¿Desde el WAS de producción, como accedo al mariadb de prod?
    Servicio: mariadb, mariadb.prod
    
¿Desde el WAS de desarrollo, como accedo al mariadb de desarrollo?
    Servicio: mariadb, mariadb.desa
    
¿Desde el WAS de desarrollo, como accedo al mariadb de produccion?
    Servicio: mariadb.prod <<< PERFECTO ... QUIERO QUE SE PUEDA REALIZAR??? Ni de coña !!!!!!! STOP, WARNING !!!!
    
    
------------------------------------------------------------------------------------------------------------------
ISTIO
------------------------------------------------------------------------------------------------------------------
                                     |                   CLUSTER DE KUBERNETES                                   |
                                     -----------------------------------------------------------------------------
CLIENTE EN MI CASA  >>>     LB >NODO>|  INGRESS_CONTROLLER  >  ServicioWAS >    WAS        ServicioOracle> ORACLE|
                                                                                   C-WAS                    C-ORACLE
                                                                                            
                                                                                           Servicio WAS > WAS
                                                                                                            C-WAS
                                                                                           Servicio Tomcat > Tomcat
                                                                                                                C-Tomcat

¿Quien tiene claras las dependencias del cluster?  
    NADIE !!!
    
    
        mTLS
WAS -- HTTPs -->  TOMCAT    
CA                  Servidor: Certificado: Su clave publica + La CA que firma el certificado
                              Su clave privada
                    CA
Certificado: Su clave publica + La CA que firma el certificado                              
Su clave privada

POD                             POD
   initContainer                    initContainer (Cambiar las reglas de IPTABLES < NETFILTER ) del POD
>  C-WAS                         >  C-Tomcat
    ^^                                  ^^  localhost
 > Envoy (Proxy)  >>>>>mTLS>>>>>>>  > Envoy (proxy)

Certificado: Su clave publica + La CA que firma el certificado      |
Su clave privada                                                     > Gestionadas en automatico por ISTIO
CA                                                                  |

Reglas de RED, si trabajo con ISTIO, quien las va a gestionar > ISTIO > Envoys