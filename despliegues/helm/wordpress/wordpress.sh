function generarSecret(){
    NAMESPACE=$1
    RANDOM=$2
    
    if[[ -z $RANDOM ]]; 
    then
        read -p "Dame la contraseña del wordpress: " PASSWORD
        PASSWORD=$(echo $PASSWORD | base64)
    else
        PASSWORD=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 10 ; echo '' | base64)
    fi
    
    cat << EOF | kubectl apply -n $NAMESPACE -f -
    kind: Secret
    apiVersion: v1
    metadata:
        name: wordpress-secret
    data:
        wordpress-password: $PASSWORD
EOF
}
function generarPVC(){
    NAMESPACE=$1
    STORAGE_CLASS=$2
    CAPACITY=$3
    VOLUME_NAME=$4
    
    cat << EOF | kubectl apply -n $NAMESPACE -f -
    kind: PersistentVolumeClaim
    apiVersion: v1
    metadata:
        name: $VOLUME_NAME
    spec:
        storageClassName: $STORAGE_CLASS
        resources:
            requests:
                storage: $CAPACITY
        accessModes:
            - ReadWriteOnce
EOF
}

function install(){
    RELEASE_NAME=$1    
    PARAMS_FILE=$2
    NAMESPACE=$3
    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm install $RELEASE_NAME bitnami/wordpress -f $PARAMS_FILE -n $NAMESPACE --create-namespace
}

function uninstall(){
    RELEASE_NAME=$1    
    NAMESPACE=$2
    helm uninstall $RELEASE_NAME -n $NAMESPACE
}


COMANDO=install
VOLUMES=0
SECRET=0
while [[ $# != 0 ]]
do
    if [[ "$1" == "--install" ]]
    then
        COMANDO=install
        shift
    elif [[ "$1" == "--uninstall" ]]
    then
        COMANDO=uninstall
        shift
    elif [[ "$1" == "--volumes" ]]
    then
        VOLUMES=1
        shift
    elif [[ "$1" == "--secret" ]]
    then
        SECRET=1
        shift
    elif [[ "$1" == "--namespace" ]]
    then
        shift
        NAMESPACE=$1
        shift
    elif [[ "$1" == "--release-name" ]]
    then
        shift
        RELEASE_NAME=$1
        shift
    elif [[ "$1" == "--storageclass" ]]
    then
        shift
        STORAGE_CLASS=$1
        shift
    elif [[ "$1" == "--capacity-wordpress" ]]
    then
        shift
        WP_CAPACITY=$1
        shift
    elif [[ "$1" == "--capacity-ddbb" ]]
    then
        shift
        DDBB_CAPACITY=$1
        shift
    elif [[ "$1" == "--password-random" ]]
    then
        shift
        RANDOM=1
        shift
    elif [[ "$1" == "--configuration" ]]
    then
        shift
        CONFIGURATION_FILE=$1
        shift
    elif [[ "$1" == "--help" ]]
    then
        echo Parámetros admitidos: --install, --uninstall, --namespace, --release-name, --storageclass, --capacity-wordpress,\
            --capacity-ddbb, --password-random, --configuration, --volumes, --secret
    else 
        echo Parámetro incorrecto:$1 . Parametros admitidos: --install, --uninstall, --namespace, --release-name, --storageclass, --capacity-wordpress,\
            --capacity-ddbb, --password-random, --configuration, --volumes, --secret
        exit 1
    fi
done

if [[ $COMMAND == "install" ]]; then
    kubectl create namespace $NAMESPACE
    if [[ $VOLUMES == 1 ]]; then
        generarPVC $NAMESPACE $STORAGE_CLASS $WP_CAPACITY wordpress-pvc
        generarPVC $NAMESPACE $STORAGE_CLASS $DDBB_CAPACITY wordpress-mariadb-pvc
    fi    
    if [[ $SECRET == 1 ]]; then
        generarSecret $NAMESPACE $RANDOM
    fi    
    install $RELEASE_NAME $CONFIGURATION_FILE $NAMESPACE
fi


if [[ $COMMAND == "uninstall" ]]; then
    uninstall $RELEASE_NAME $NAMESPACE
fi