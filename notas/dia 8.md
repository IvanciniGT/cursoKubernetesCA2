Unir máquinas a un cluster de Kubernetes

Cluster 1: Alejandro* Alexandre Antoni Carlos
Cluster 2: Carme*, Erneto, Ignasi, Jonathan
Cluster 3: Jose Antonio Esteban*s, Marc, Pablo, Valentin


kubeadm reset   Limpiar toda la configuración de cluster que teniamos

Este comando en los nodos maestros
kubeadm token create --print-join-command

sudo kubeadm join ....


kubectl get nodes

cp $HOME/.kube/config ~/environment

cp ~/environment/config $HOME/.kube
thisisunsafe

Cluster 4/5 nodos
    Pod nginx -> nodo con una determinada label nombre: Ernesto
    Pod2 mariadb (deployment) -> mismo namespace del pod nginx:
        Ponerle una regla de afinidad:
            Instalate en el mismo nodo que el pod de nginx
                Afinidades entre pods

----

Desarrollo: -> 
    Código de un programa: Repo Sistema de control de versión: GIT
    Ese código lo querríamos ejecutar dentro de un Contenedor:
        - Si soy el desarrollador para ejecutarlo lo haré posiblemente con Docker
        - Para instalarlo en pre, pro lo meteremos dentro de un kubernetes.
    ¿Que voy a necesitar para tener el código dentro de un contenedor? Una imagen de contenedor.
    De dónde sale esa imagen?
        ¿La hace el desarrollador? Puede ser
        El perfil Devops
        Cómo generamos una imagen de contenedor? 
            docker por ejemplo nos ayuda con eso:
                contenedor -> imagen (manual)
                montar un fichero Dockerfile (script) (automatizado)
                    Partir de una imagen base (ubuntu, fedora, alpine)
        
    * Adicionalmente 
        Necesitaremos un chart de Helm
            Puede hacerlo el desarrollador
                             devops
----
Dev ---> ops: Cultura de Automatizar el qué? TODO desde des a ops.... pruebas, instalaciones
Perfil devops: Jenkins, docker, Ansible

CI: Integración Continua: Qué es esto?
Automatizar todo hasta la fase de testing
    Compilar el código del desarrollador
    Generar en auto una imagen de contenedor
    Registrar esa imagen de contenedor en un repo de artefactos
    Instalar la app en un sitio (pej: Kubernetes)
        Necesito ficheros de despliegue (Deployments, Services,....) AUTOMATIZAR < Charts de HELM
        Cambian en función del entorno
    Hacer las pruebas en automático

Jenkins : Servidor de CI/CD
AzureDevops
TravisCI
Bamboo

-----
Helm 

Helm dispone del concepto de CONTEXTO, 
    del cual recuperamos información
    
Helm me da distintas variables (datos) a las que puedo acceder 
Los datos se ubican dentro de un contexto.

Pensad en el contexto como si fuera un filesystem LINUX

/home/ubuntu
     ^ Dentro de
^ RAIZ    

Igual ocurre en HELM
El contexto raiz se llama $
Dentro de lo marcamos con un PUNTO

Por defecto, cuando arrancamos HELM, 
    se me posiciona en el contexto $, en el RAIZ de los datos
    

values.yaml <<< sobre este sobrescribe los datos de los 
                ficheros específicos que se suministren
            <<< sobre lo generado sobreescribe los datos 
                introducidos mediante el argumento --set
                
                

Chart configES   <<<<<< values.produccion aumentar memoria
                >>>> Te va a generar unos pods nuevos.
                     Pero el service, el ingress, ... 
                     siguen en funcionamiento
    Secrets                    
    ConfigMaps
    ^^^^
Chart ES   <<< redeploy
                borrado y creado desde cero
                    No tengo sistema
    Deployments
    Services
    Ingress
    StatefulSet