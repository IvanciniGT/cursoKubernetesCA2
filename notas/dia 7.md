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
