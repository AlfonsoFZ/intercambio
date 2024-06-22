FROM debian:bullseye

#actualizamos gestor de paquetes e instalamos solo lo necesario 
#buenas practimas recmienda esta opción para asegurarnos que no 
#si agregamos nuevos paquetes a instalar no se usen las versiones
#de los paquetes que se encuentran en cache

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    mariadb-server \ 
    && rm -rf /var/lib/apt/lists/*

#copiamos el archivo de configuración previemente editado
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

#copiamos el script y damos permisos de ejecución
COPY ./tools/script_mariadb.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/script_mariadb.sh

# comentado para ver si es estrictamentenecesario
# RUN service mariadb start

#exponemos el puerto para su conexión
EXPOSE 3306

# CMD ["/mysqld"]
CMD ["script_mariadb.sh"]
