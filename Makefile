NAME = inception
DCF = ./srcs/docker-compose.yml

# # Nombres de los volumenes a crear
VOL1 = data/mariadb
VOL2 = data/wordpress

# Definición de la regla por defecto levantamos y dejamos en segundo plano
# usando $DCF como archivo de configuración
all: create_vols
	@echo "Composing... ${NAME}..."
	@docker compose -f $(DCF) up -d

# Regla para crear el directorio si no existe
create_vols:
	@if [ ! -d "$(VOL1)" ]; then \
			echo "Creando el directorio $(VOL1)"; \
			mkdir -p $(VOL1); \
			chmod 777 $(VOL1); \
		else \
			echo "El directorio $(VOL1) ya existe";\
		fi
	@if [ ! -d "$(VOL2)" ]; then \
			echo "Creando el directorio $(VOL2)"; \
			mkdir -p $(VOL2); \
			chmod 777 $(VOL2); \
		else \
			echo "El directorio $(VOL2) ya existe";\
		fi

# comandos para inciar bash en contenedores por separados
bashmdb:
	@docker exec -it mariadb bash

bashngx:
	@docker exec -it nginx bash

bashwdp:
	@docker exec -it wordpress bash 

# para todos los contenedores - ejecutar antes de elminar alguno
stop:
	@docker stop wordpress nginx mariadb

#elimina todos los contenedores 
rm :
	@docker rm wordpress mariadb nginx

#elimina todas las imágenes 
rmi:
	@docker rmi -f ${NAME}-mariadb 
	@docker rmi -f ${NAME}-wordpress
	@docker rmi -f ${NAME}-nginx

# construye los contendores (up) y los deja en segundo plano (-d) 
# despues de construir las immágenes (--build) usando el archivo de configuración $DCF (-f)
build:
	@printf "Constuyendo ${NAME}, con docker compose -f $(DCF) up -d --build"
	@docker compose -f $(DCF) up -d --build

# detiene y elimina todos los recursos de Docker que se crearon con docker compose up menos las imágenes
down:
	@echo "Deteniendo ${NAME}, running docker compose -f $(DCF) down"
	@docker compose -f $(DCF) down

re:	down
	@echo "Reconstruyendo ${NAME}..."
	@docker compose -f $(DCF) up -d --build

# con prune eliminamos los recursos no usados, ya sean contendores no usados, imágenes sin referenciar o redes y volúmenes sin uso
#	
clean:  
	@printf "Limpiando elementos no usados de ${NAME}..."
	@docker system prune -a

fclean: down
	@echo "Borrado total de Docker"
	@docker rmi -f ${NAME}-mariadb
	@docker rmi -f ${NAME}-wordpress
	@docker rmi -f ${NAME}-nginx
	@docker volume rm -f 4_inception_mariadb_data_vol
	@docker volume rm -f 4_inception_wordpress_data_vol
	@docker system prune -a
	@sudo rm -rf $(VOL1)
	@sudo rm -rf $(VOL2)

check:
	@echo "checking running containters, other containers and images" 
	@docker ps 
	@docker ps -a 
	@docker images 



.PHONY	: all build down re clean fclean bashmdb bashngx bashwdp stop rm rmi check 
