FROM debian:bullseye

RUN apt-get update -y && \
    apt-get upgrade -y && \ 
    apt-get install -y --no-install-recommends \
    nginx   \
    openssl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -subj "/C=SP/ST=Malaga/L=Malaga/O=42 Malaga/OU=alfofern/CN=alfofern" \
    -keyout /etc/nginx/ssl/alfofern.key -out /etc/nginx/ssl/alfofern.crt

COPY conf/default /etc/nginx/sites-available/default

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
