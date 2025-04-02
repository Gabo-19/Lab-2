#!/bin/bash
#se definen las rutas del directorio a monitorear y el archivo de log 
DIRECTORIO=/home/gabo1909/directorio_monitoreado
LOG=/home/gabo1909/cambios.log
#Crea el archivo si no existe 
touch "$LOG"

echo "Monitoreando los  cambios en $DIRECTORIO"
#bucle infinito para monitorer el directorio 
while true; do
	#se usa inotify para detectar cambios en el directorio
	inotifywait -e create -e modify -e delete --format '%T %w %e %f' --timefmt '%Y-%m-%d %H:%M:%S' "$DIRECTORIO" | while read FECHA RUTA EVENTO ARCHIVO; do
	echo "[$FECHA] Evento: $EVENTO en archivo: $ARCHIVO" >> "$LOG" #guarda el evento detectado en el archivo de log
   done
done 


