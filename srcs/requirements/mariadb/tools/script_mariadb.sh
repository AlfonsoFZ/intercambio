#!/bin/bash

# Crear directorios necesarios y establecer permisos
mkdir -p /var/run/mysqld && chown -R mysql:mysql /var/run/mysqld  
mkdir -p /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql

#iniciamos en segundo plano
echo "ejecutando service mariadb start";
service mariadb start

until mysqladmin ping > /dev/null 2>&1; do
	sleep 3
done

# mysql - e nos permite ejecutar SQL desde la línea de comandos,
# es decir sin entrar al entorno mysql

#creamos base de datos si no existen y usuarios
mysql -e "CREATE DATABASE IF NOT EXISTS $MARIADB_NAME;"
mysql -e "CREATE USER IF NOT EXISTS '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASS';"

# garantizamos permisos y los concedemos con flush
mysql -e "GRANT ALL PRIVILEGES ON *.* TO '$MARIADB_USER'@'%' with grant option;"
mysql -e "flush privileges;"

#reiniciamos par que los cambios se apliquen - ojo ver opción de hacer como Ismael
pkill -f mysqld
mysqld
