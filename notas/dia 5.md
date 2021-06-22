# Cluster ElasticSearch-Kibana: Stack ELK

Indexador / Motor de búsqueda (FULLTEXT) <<< Montar nuestro propio GOOGLE 
10%  instalaciones se usan para esto.
90% instalaciones de ES hoy en dia se utilizan para sistemas de monitorización


Pensada para trabajar en un cluster
Master 1* |
Master 2  | Cluster Activo Pasivo
Master 3  | 
    Por un lado... van a generar sus propios archivos de log. Cada nodo irá generando los suyos propios:
    Los archivos de log los genero sobre un volumen de tipo EMPTY DIR  <<< Aquí cada pod que yo genere tendrá su propia carpeta.
        DEPLOYMENT
    A mi, como cliente, me daría igual trabajar contra un maestro u otro?
        No me da igual... Solo hay 1 que sea maestro.
        Estos pods, aun no teniendo necesidad de volumenes propios (independientes) de alguna forma tiene su propia identidad.
        KUB: StatefaulSet
    
Data 1 (Guardan los datos, indexan y hacen búsquedas)
Data 2
Data 3
Data 4
    Replicación de la información
    Fragmentación de la información < Escalabilidad:
        Cada nodo va a tener unos datos diferentes a los demás.
            Los datos se guardan en Archivos un HDD
    EN KUB: Tiene que se un StatefulSet. Cada uno tenga su propia carpeta de almacenamiento de información

Ingesta 1  Son los que prepararn los datos para su indexación
Ingesta 2

Coordinador 1 Que se encargan de dar la cara con respecto a los clientes de ES 
Coordinador 2  Principalmente se encarga de recepcionar y preparar las búsquedas

Kibana 1 - Interfaz gráfica para explotar los datos que tengo en ES
Kibana 2
    Los kibanas son iguales entre si. Ya que ellos no guardan datos (sus datos realmente os guardan en ES)
A mi realmente me da igual además que me pongan a trabajar contra un Kibana u otro... Son iguales.
    EN KUB: Deployment
    
    Kibana ofrece una interfaz gráfica WEB que tiene que ser accesible a los usuarios finales (serán seres humanos)
        Esa interfaz funciona en el puerto 5601 <<<< SERVICIO
    Como variables de configuraión tendremos que especificar:
        SERVER_NAME: nombre del nodo concreto /particular, utilizado internamente para identificar cada kibana
        SERVER_HOST: nombre del servicio a través del cual llegamos a kibana
        ELASTICSEARCH_HOSTS: Apuntar a los nodos coordinadores, en su ruta completa: http://NOMBRE_IP_COORDINADOR:9200
    Sabiendo que la imagen de kibana es igual que la de elasticsearch, pero poniendo "kibana" donde pone "elasticsearch"
    Kibana no necesita su propio volumen persistente de ningún tipo... ya que sus datos los guarda en ElasticSearch
    