# 02 – Servidor FTP con Docker Compose

Levanta un servidor FTP usando la imagen `fauria/vsftpd`.

| Variable        | Valor por defecto | Descripción                        |
|-----------------|-------------------|------------------------------------|
| `FTP_USER`      | `ftpuser`         | Nombre de usuario FTP              |
| `FTP_PASS`      | `ftppass`         | Contraseña FTP                     |
| `PASV_ADDRESS`  | `192.168.100.3`   | IP para modo pasivo (IP del servidor) |
| `PASV_MIN_PORT` | `21100`           | Puerto mínimo para modo pasivo     |
| `PASV_MAX_PORT` | `21110`           | Puerto máximo para modo pasivo     |

El directorio `/home/vagrant/ftp` del host se monta en el contenedor como
el directorio de datos del usuario FTP.

## Prerrequisitos (servidorUbuntu)

El script `provision-server.sh` ya crea y configura `/home/vagrant/ftp`
automáticamente. Si necesitas hacerlo a mano:

```bash
sudo mkdir -p /home/vagrant/ftp
sudo chmod 777 /home/vagrant/ftp
sudo service vsftpd stop || true
```

## Uso

```bash
# Desde servidorUbuntu
cd ~/repo/compose/02-ftp-compose

# Validar configuración
sudo docker compose config

# Levantar
sudo docker compose up -d

# Ver estado
sudo docker compose ps

# Verificar que el puerto 21 escucha
sudo ss -lntp | grep ':21' || true

# Bajar
sudo docker compose down
```

## Prueba rápida con cliente FTP

```bash
sudo apt-get install -y ftp
ftp 127.0.0.1
# usuario: ftpuser
# contraseña: ftppass
```
