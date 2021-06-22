Elastic -> ELK   ElasticSearch + Logstash + Kibana (+ BEATS)

NagiOS  -> Prometheus / Grafana  -> ELK

Kubernetes - Prometheus / Grafana
-
    Servidores de aplicaciones
        -> log access           > ELK
        -> app log
    Servidores Web
        -> log access           > ELK
        -> app log

------------------------
Página WEB
App WEB para la gestión de mis cuentas bancarias: Cluster
    5 Serv Apps
        ---> Access Log

Cada AppServer se ejecuta en 1 contenedor
    que en kubernetes estaría en un Pod
        Ese pod lo generaríamos desde un Deployment/StatefulSet

Imaginad que quiero extraer los logs de los app servers (access log)
    y llevarlos a ES para su monitorizacion

1º Montar un cluster de ES
2º Montar un Kibana
3º Alimentar ES con los logs
    Necesitariamos un programa capaz de leer los ficheros de log y mandarlos a ES.
        Fluentd | Filebeat
    Esos programas además deberían tener acceso a los ficheros de log

4º Montamos un volumen, donde? HDD <<< MEMORIA. Problema? Espacio + Volatil
    Fluentd + Filebeat -> ES (persistencia)
    2 ficheros de log 50kb - 100kb = 200kb
5º Donde ejecuto el Fluentd o filebeat? En el contenedor del Serv Apps? NO
   En su propio contenedor
6º Para que ese contenedor tenga acceso al volumen EN RAM que usamos en el contenedor
   del serv de apps, que tengo que tener garantizado: Mismo NODO
7º Para cada App server, se genere 1 Contenedor con Fluentd o Filebeat
                                                        ^^^
                                                        Sidecar
8º POD: Conjunto de contenedores que:
    - Tengo garatizado que se ejecutan en el mismo nodo
    - Escalan de la misma forma
    
APP Server >>> Fichero log (RAM)
                    ^^^^
                    Filebeat / Fluentd  >> ASincrona <<<  Logstash >>> ElasticSearch
                                            ^^^^
                                            Sistema de mensajería (KAFKA)
-------------------------
Deployments / Statefulset < Escalabilidad de mis apps (replicas)
En un fichero pongo quiero 2 replicas... quiero 10 replicas....

$ kubectl scale deployment XXXX --replicas=10

¿Cual es el objetivo? Automatizar el escalado
HorizontalPodAutoscaler <<< No nos va a funcionar tal y como tenemos el sistema
No tenemos a nadie recopilando metricas <<<<<< 
Cuando la CPU de los pods llegue al 50% escala hacia arriba.
Sobre lo asignado al POD?


--------
Automatizar instalaciones
Gestión de volumenes <<< Creando volumenes a mano
    Localhost <<< AWS
Automatizar Alta disponibilidad:
    1º Monitorizar los procesos
    2º Kubernetes ya se encarga de tener enb marcha esas apps... 
       Si no están en funcionamiento intentar ponerlas en marcha de nuevos
Automatizar Balanceo de carga (Servicio)

--------
Quiero un Horizontal Pod Autoscaler
1 - Montar un YAML para el HPA
2 - kubectl apply -f 

--------------------------------------------------------------
Quien decide qué recursos pueden utilizarse por un pod?
 memoria / cpu

>>>> Administrador
>>>> Developer

El desarrollador que haría cuando quiere instalar una app en el cluster?
- Necesito al menos 1 Gb de RAM por pod y 2 cpus por pod (PETICION DE MINIMOS - REQUEST)
- SOBRE qué hace la petición un desarrollador: A NIVEL DE CONTENEDOR DE CADA POD CONCRETO que quiera instalar

Qué hace el adnministrador?
- Verificar si se lo puede dar - VERIFICAR LOS REQUEST (MINIMOS)
- Limitar el uso de CPU y RAM del pod - MAXIMOS - LIMITS
- SOBRE QUE LIMITA EL? 
    - Limita cada pod/contenedor concreto? NO
    - Se hace a nivel de Namespace
        - En el namspace X no me pueden pedir contenedores que requieran más de 1Gb de RAM
        - En el namspace X no me pueden pedir PODS que en total (con todos sus contenedores) requieran más de 4Gb de RAM
        - En el namspace X no me pueden pedir en total de los totales más de 8Gb de RAM
                En el namespace bases-datos-desarrollo no puedes estar usando más de 4 Gbs de RAM en TOTAL
                    Repartelas entre el MariaDB, el postgreSQL, el oracle

Quien toma en cuenta ese minimo (REQUEST) que estamos definiendo:
    SCHEDULER: Cuando decide en qué nodo mete un POD, tiene que poder garantizar esos recursos en ese Nodo


NodoA
    2 cpus
    2 Gbs RAM

NodoB
    2 cpus
    4 GBs de RAM
    
    
Quiero montar un POD que requiere al menos 3 Gbs de RAM y 1 cpu. Decision del Scheduler: Nodo B
Quiero montar un POD que requiere al menos 1 Gbs de Ram y 1 cpu. Decisión del Scheduler: Nodo A
Quiero montar un POD que requiere al menos 2 Gbs de Ram y 1 cpu. Decisión del Scheduler:
Mueve el segundo pod al B y el nuevo va a A
Mover va a significar: ME CRUJO el pod en el nodo A, lo borro, y creo uno nuevo en el nodo B


NodoA Lo comprometido es 1Gb
    2 cpus
    2 Gbs RAM

Quiero montar un POD 1 que requiere al menos 1 Gbs de Ram y 1 cpu. Decisión del Scheduler: Nodo A
Quiero montar un POD 2 que requiere al menos 2 Gbs de Ram y 1 cpu. Decisión del Scheduler: Pending No se monta
Como no tengo limites, el POD 1 se flipa y toma los 2 Gbs de RAM
Quiero montar un POD 3 que requiere al menos 1 Gbs de Ram y 1 cpu. Decisión del Scheduler: Nodo A
Se carga el primer POD 1, lo levanta de nuevo
Y asigna el pod 3 también al nodo A
Si a partir de ese momento alguno de los pods trata de tomar mas de ! Gbs de RAM: Se lo cruje otra vez 
y pa'rriba de nuevo

Servidor de Aplicaciones (Websphere) JAVA . JVM < Asignación de memoria... Si mi jvm necesita mas memoria que 
    ocurre? Explota, explota, explotó!!!!
    
El extra de RAM de un contenedor a qué se DEBE dedicar? CACHES! <<<< Rendimiento de la app

En el WAS no tendré solo 1 pod en marcha... Tendré varios... cluster.
    Entre ellos activaré replicación de sesiones