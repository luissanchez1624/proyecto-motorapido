#!/bin/bash

while true
do
    echo "================================" >> /srv/motorapido/reportes/estado_servidor.log
    echo "Fecha: $(date)" >> /srv/motorapido/reportes/estado_servidor.log
    echo "Servidor: $(hostname)" >> /srv/motorapido/reportes/estado_servidor.log
    echo "Tiempo encendido: $(uptime -p)" >> /srv/motorapido/reportes/estado_servidor.log
    echo "Estado: SERVIDOR FUNCIONANDO" >> /srv/motorapido/reportes/estado_servidor.log

    sleep 60
done
