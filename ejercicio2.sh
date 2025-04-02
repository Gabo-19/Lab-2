#!/bin/bash
#Verifica si no se paso ningun argumento 
if [ $# -eq 0 ]; then
	echo "Uso: $0 <comando_a_ejecutar>" #muestra como se deberia de ejecutrar
	exit 1
fi
#Ejecuta el comando recibido en segundo plano
$@ &
PID=$! #Guarda el id del proceso iniciado
echo "Proceso iniciado con PID $PID"

#Define el nombre del archivo de log
LOG="reporte_proceso.log"
echo "Tiempo,CPU,MEM" > "$LOG"
#While para monitorer el proceso mientras este en ejecucion
while ps -p $PID > /dev/null; do
	TIEMPO=$(date +%H:%M:%S) #Obtien la hora
	CPU=$(ps -p  $PID -o %cpu --no-headers) # obtiene el uso del cpu del proceso
	MEM=$(ps -p  $PID -o %mem --no-headers) # obtiene el uso de memoria del proceso
	echo "$TIEMPO,$CPU,$MEM" >> "$LOG" #escribe los datos en el archivo de log 
	sleep 1 # espera un segundo para tomar datos nuevamente
done

GNUPLOT_SCRIPT="grafica.gnuplot"

#crea el script para gnuplot que generea una grafica 
echo "set datafile separator ','" > "$GNUPLOT_SCRIPT"
echo "set terminal png" >> "$GNUPLOT_SCRIPT"
echo "set output 'grafico.png'" >> "$GNUPLOT_SCRIPT"
echo "set title 'Uso de CPU y MEMORIA'" >> "$GNUPLOT_SCRIPT"
echo "set xlabel 'Tiempo'" >> "$GNUPLOT_SCRIPT"
echo "set ylabel '% de uso'" >> "$GNUPLOT_SCRIPT"
echo "set xdata time" >> "$GNUPLOT_SCRIPT"
echo "set timefmt '%H:%M:%S'" >> "$GNUPLOT_SCRIPT"
echo "set format x '%H:%M:%S'" >> "$GNUPLOT_SCRIPT"
echo "plot 'reporte_proceso.log' using 1:2 with lines title 'CPU', '' using 1:3 with lines title 'MEM'" >> "$GNUPLOT_SCRIPT" #define la forma en que se graficaran los datos del arachivo reporte_proceso.log
#lo ejecuta
gnuplot "$GNUPLOT_SCRIPT"
