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

## Prerrequisitos (servidorUbuntuDC)

El script `provision-server.sh` ya crea y configura `/home/vagrant/ftp`
automáticamente. Si necesitas hacerlo a mano:

```bash
sudo mkdir -p /home/vagrant/ftp
sudo chmod 777 /home/vagrant/ftp
sudo service vsftpd stop || true
```

## Uso

```bash
# Desde servidorUbuntuDC
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

## Prueba rápida con cliente FTP (curl)

```bash
sudo apt-get install -y ftp curl
curl ftp://ftpuser:ftppass@127.0.0.1/ --verbose
```

## Usar lftp (recomendado para pruebas y scripts)

Instalar lftp (Ubuntu/Debian):

```bash
sudo apt-get update
sudo apt-get install -y lftp
```

Conectar (modo interactivo):

```bash
lftp -u ftpuser,ftppass 127.0.0.1
```

Comandos útiles dentro del prompt de lftp:

- ls          # listar directorio remoto
- pwd         # ver directorio actual remoto
- put fichero # subir fichero desde host local al servidor FTP
- get fichero # descargar fichero desde servidor FTP al host local
- bye         # salir

Comando no interactivo (listar y salir):

```bash
lftp -u ftpuser,ftppass 127.0.0.1 -e "ls; bye"
```

### Subir el propio README.md como prueba

Hay varias formas de subir el README.md del repositorio al servidor FTP para probar que las transferencias funcionan.

Opción A — Subir desde la máquina host usando lftp (desde la carpeta del repo):

```bash
# Sitúate en la carpeta donde está README.md
cd ~/repo/compose/02-ftp-compose

# Subir README.md al servidor FTP y renombrarlo a README_en_FTP.md
lftp -u ftpuser,ftppass 127.0.0.1 -e "put README.md -o README_en_FTP.md; bye"

# Verificar con curl (lista):
curl ftp://ftpuser:ftppass@127.0.0.1/ --verbose
```

Opción B — Copiar el README.md directamente en el volumen montado (no requiere FTP):

```bash
sudo cp ~/repo/compose/02-ftp-compose/README.md /home/vagrant/ftp/README_subido.md
sudo chown vagrant:vagrant /home/vagrant/ftp/README_subido.md || true
ls -l /home/vagrant/ftp/README_subido.md
```

Luego puedes listar desde el cliente FTP para comprobar que aparece.

## Notas sobre conexiones desde otras máquinas

- Si vas a conectar desde otra máquina en la LAN o desde Internet, asegúrate de que `PASV_ADDRESS` en `docker-compose.yml` sea la IP alcanzable por el cliente (ej. 192.168.x.y o la IP pública) y que el firewall/routers permitan TCP/21 y TCP/21100:21110.
- Para pruebas locales (cliente en la misma máquina que el servidor) el uso de EPSV funciona y la conexión de datos se hace a la IP/localhost (como 127.0.0.1) sin cambiar `PASV_ADDRESS`.

## Depuración

- Ver contenedores:
  sudo docker compose ps
- Ver logs del servicio:
  sudo docker compose logs ftp --tail 200
- Ver puertos en escucha:
  sudo ss -lntp | egrep ':21|2110' || true

---

Si quieres, puedo preparar un pequeño script que instale lftp, cree un archivo de prueba, lo suba al servidor y guarde las salidas en archivos para entregar como evidencia.