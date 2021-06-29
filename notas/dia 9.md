github < WEBSITE (index.html)
nginx < HA y escalabilidad dentro de Kubernetes

nginx < Entre sus capacidades de un servidor web

Imagen de nginx.... necesitamos dentro de la imagen la WEB?
ALTERNATIVA 1: Dockerfile???? No habeis dicho que lo ponemos después? Este permite crear nuestra propia IMAGEN DE CONTENEDOR
                              que ya lleve la web integrada
ALTERNATIVA 2: No.. la ponemos luego < Descargándola... donde? en el contenedor.... cómo? VOLUMEN !
                Cuando se rellena el volumen? 
                Cuando acaba el despliegue del container.... que implica esto? operativamente?
                Cada vez que se rehaga el container meto la web.
                Quién controla la descarga y si ya existe o no? COMMAND:
                    A quien llama el COMMAND del contenedor? a un script que haga qué?
                        1 Que compruebe si ya existe la web en el volumen. IF si existe una carpeta? instantaneo
                        2 Si no < que la descargue
                        3 Arrancar nginx
                Veis esta solución limpia? Un poco guarrilla... por qué?
                    Tener que tocar el comando base de la imagen... Estoy perturbando el contenedor de nginx.
                    Imagina que viene una versión nueva de nginx. Que arranca de otra forma, con otro comando, con otros parámetros...
                        Esto me obligaría a tocar mi script.
                    Es un sistema FUERTEMENTE ACOPLADO
    
POD(s) - Contenedor nginx
            Volumen < web <<<< Esto hay que ponerlo aquí
INIT CONTAINER 
    Es un contenedor que arranca, ejecuta su trabajo y finaliza. Su trabajo va a ser un script <
    
En Kubernetes dentro de un POD:
    Primero se ejecutan secuencialmente los init containers
    Despues arrancan los containers... Si tengo varios, cómo arrancan? En paralelo entre si
    
    
POD
    InitContainers:
        InitContainer 1
        InitContainer 2
        InitContainer 3
    Containers:
        Container A
        Container B
        
Orden de ejecución:
    InitContainer 1 > InitContainer2 > InitContainer 3 > Container A y Container B en paralelo


En nuestro caso del nginx
Que vamos a hacer?
    - Deployment:
        Plantilla POD:
            InitContainer:
                Contenedor < Imagen de contenedor... Cual uso?
                    Cualquiera que me permita:
                        Ejecutar un script de la bash y ejecutar en nuestro caso el comando git
                Su misión: Cargar la página en el volumen.... siempre que no exista previamente
            -----------------    
            Contenedor nginx
                ^
            Volumen: En base a un claim
        Por qué? Quiero un volumen compartido entre TODAS las replicas.
    - PVC 
    - PV autoprovisionado (ideal) !!!
    - Servicio
    - ConfigMap
        La URL Del REPO GIT
        
------

Deployment:
    replicas
    plantilla de pods
    
Statefulset
    replicas
    plantilla de pods
    plantilla de pvc
    
Quien tiene dentro un volumen ???? POD < PVC < PV

----

Para instalar paquetes dentro de Ubuntu usamos apt-get
apt-get trabaja con el concepto de REPOSITORIO.

Ubuntu es un distro de Linux basada en Debian. En Debian el instalador de paquetes es: apt

Si trabajasemos con una distro de linux basada en la familia Redhat: RHEL, Fedora, CentOS, Oracle Linux... yum

----
Cuando un pod está en pending:
    Cuando el scheduler no consigue asignarlo a un nodo.
    Motivos:
        - Volumen. Necesito un volumen y no se encuentra dispobile... Es nuestro caso? NO
        - Recursos: No se cumplen los recursos minimos
        
---

Prueba de vida del contenedor: Liveness peticion http

3 tipos de pruebas asociadas a los contenedores:
    StartupProbe
        Se ejecuta al arranque de un contenedor. 
        Una vez la prueba se da por buena, deja de ejecutarse
    
    ------- Estas dos pruebas se ejecutan indefinidamente VVVV
    ReadinessProbe
        Prueba cuya misión es determinar si el contenedor está listo 
            y por tanto puede ponerse como backend del correspondiente servicio
        Ejemplos:
            Modo mantenimiento
            Actualización               JENKINS
            Carga de datos en cachés
            Indexación de datos
    LivenessProbe
        Prueba cuya misión es determinar si el contenedor está en un estado saludable
            porque si no lo está kubernetes lo reinicia (se lo carga y crea otro)
    
Objetos de Kubernetes:
    Node
    Namespace
    Pod
    PodTemplate
    Deployment
    StatefulSet
    DaemonSet
    PV
    PVC
    Service
    ConfigMap
    Secrets
    NetworkPolicy
    ResourceQuota
    LimitRange
    HorizontalPodAutoscaler
    Ingress
    ServiceAccount
    Role
    RoleBinding
    ClusterRole
    ClusterRoleBinding
Kubernetes es extensible. Podemos ampliar la funcionalidad de Kubernetes mediante la instalación de Operators
    Crearnos más tipos de objetos dentro de kubernetes
    Openshift
    ISTIO

----
kubectl create namespace miweb-ivan
kubectl label namespace miweb-ivan istio-injection=enabled