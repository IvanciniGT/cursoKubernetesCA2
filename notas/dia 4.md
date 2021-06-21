VOLUMENES EN KUBERNETES
-----------------------------------------------------------
Aquí es donde se guarda la información de forma persistente


FileSystem de los contenedores 
-----------------------------------------------------------
Se monta mediante la superposición de CAPAS:
                                    VVVVVVV


VOLUMENE1  (Directorios/archivos)   más archivos arriba
VOLUMENE2  (Directorios/archivos)   más archivos arriba
VOLUMENE3  (Directorios/archivos)   más archivos arriba
VOLUMENE4  (Directorios/archivos)   más archivos arriba
VOLUMENE5  (Directorios/archivos)   más archivos arriba
Capa Contenedor: D.CARPETA    -     vacia
Capa Base:  Docker CARPETA    -     IMAGEN DEL CONTENEDOR

Gracias a esa forma de trabajo tenemos PERSISTENCIA 
AL BORRAR UN CONTENEDOR


Nodo1 PUF ! 
    P1- C1 -V1(AWS)
Nodo2
    P2- C2
    P1- C1 ??? Que pasas con el V1?
Nodo3
    P3- C3
    
Si V1 está en el HOST... me acabo de quedar sin los datos... LIQUIDAOS !!!
    RUINA !!!!!!
    
Los volumenes que necesiten persistencia de datos... 
    los tengo que guardar FUERA DEL HOST. Pej:
        - NFS < 10Gb.... Todo lo que haya en el disco duro
        - Fibre-channel  LUN -> 20Gb 
        - iscsi
        - Volumenes: Clouds: 
            - AWS       
            - GCL
            - AZURE
            - OPEN-STACK
            
Donde va la definición de un VOLUMEN? A nivel de POD/PLANTILLA DE POD
Quien hace un POD? De quien es responsabilidad? DESARROLLADOR
Tiene que conocer el desarrollador donde se están guardando los datos? NO, NI DE COÑA !!!!
    Información SENSIBLE.
Acaso no puede cambiar el lugar donde voy a guardar los datos?

Quién toma la deciisón de donde están los datos: ADMIN KUBERNETES.

PLANTILLA DE POD:
    ---> VOLUMEN ----> Asociarle a una PETICION DE VOLUMEN PERSISTENTE: PERSISTENT VOLUME CLAIM
    o pvc: Un nuevo tipo de objeto que tenemos en Kubernetes
    
El Administrador del Cluster:
Crear PERSISTENT VOLUMES: pv

pvc - pv ? Quien la hace? Kubernetes en base a unos criterios

Provider < Alguien (POD) que se va a encargar de generar volumenes persistentes (pv) de forma automatica

[ Plantilla - Volumen ] <>  [ pod ] <> [ Peticion de volumen ] <> [ volumen persistente ]
DESARROLLADOR              KUBERNETES      DESARROLLADOR               ADMINISTRADOR / PROVIDER CREADO POR EL ADMIN
                        
DIA 0: Carga una petición de volumen persistente. Si hubiera un volumen disponible, se habría asociado en automatico.
DIA 1: Carga una plantilla de POD
    En cuanto cargamos una petición de volumen, en automatico Kubernetes (controller-manager) intenta asignarle a esa pvc un volumen persistente: pv
DIA 2: KUBERNETES: Scheduler: Va mirar donde genera una instancia del pod --- Hay algun PV (volumen) ya vinculado al pvc (petición) que se realiza en el pod?
                NO - Marca el POD como Pending
                SI - Instala el POD17654
DIA 3: Todo funciona genial... MAFALDA CONTENTA !!!!!
DIA 4: El POD17654 expllta explota... explotó!  
       Levanta oro POD: Scheduler: Va mirar donde genera una instancia del pod --- Hay algun PV (volumen) ya vinculado al pvc (petición) que se realiza en el pod?
                SI - Instala el POD9999... que volumen va a usar? el mismo de antes... por qué? por que el pod tiene asociada la misma pvc
                
Duda ? problema ????? SIII PROBLEMA !!!!
    Y si escalo? y genero 5 pods, todos tienen el mismo volumen? SI y eso nos vale? DEPENDE la app
        En ocasiones si.... DEPLOYMENT
        Cuando necesite para cada instancia de pod un volumen independiente: STATEFULSET
        
ESTO ERA ANTES... Esto ha cambiado    Utilizar los mismo prefijos del SI medidas     
1 Gb: 1000 Mb = 1000 x 1000 Kb = 1000 x 1000 x 1000 b


1 Gi: 1024 Mi = 1024 x 1024 Ki = 1024 x 1024 x 1024 b


        persistentVolumeClaim:
              claimName: 