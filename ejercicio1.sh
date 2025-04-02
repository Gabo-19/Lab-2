#!/bin/bash

#Verifica que el id del usuario sea 0 que es el del root  sino termina el programa
if [ "$EUID" -ne 0 ]; then
	echo "Este script debe ejecutarse como root."
	exit 1
fi

#Verifica que se pasan 3 argumentos
if [ $# -ne 3 ]; then
	echo "Uso: $0 <usuario> <grupo> <ruta_al_archivo>"
	exit 1
fi

#Se asignan las variables los argumentos a variables
USUARIO=$1
GRUPO=$2
ARCHIVO=$3

#Revisa que el archivo existe  diciendo si no existe muestra el error
if [ ! -f "$ARCHIVO" ]; then
	echo "El archivo $ARCHIVO no existe."
	exit 1
else
	echo "El archivo $ARCHIVO si existe."
fi

if grep -q  "^$GRUPO:" /etc/group; then # busca si el grupo ya existe 
	echo "El grupo '$GRUPO' ya existe."
else
	echo "Creando el grupo '$GRUPO'"
	addgroup "$GRUPO" #crea el grupo si no existe
fi

if id "$USUARIO" &>/dev/null; then #verifica si el usuario existe y sino manda la salida al agujero negro
	echo "El usuario '$USUARIO' ya existe." 
else
	echo "Creando el user '$USUARIO'"
        adduser "$USUARIO" # Crea el usuario si no existe 
        echo "Agregando el usuario '$USUARIO' al grupo '$GRUPO'"
        usermod -aG "$GRUPO" "$USUARIO"  #agrega el ususario al grupo
fi

chown "$USUARIO":"$GRUPO" "$ARCHIVO"   #cambia el owner de, archivo al usuario y al grupo 
echo "Se cambio el owner $USUARIO:$GRUPO"
chmod 740 "$ARCHIVO" #7 = owner tiene todos los permisos 4 = grupo solo lectura 0 = otros sin permisos
echo "Se cambiaron los permisos " 

