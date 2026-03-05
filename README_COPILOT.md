````
# Práctica Docker Compose (sin desafíos)

> Este repositorio implementa la práctica de Docker Compose con Vagrant (Ubuntu 22.04) y scripts de aprovisionamiento.
> **Importante:** NO incluye ni desarrolla la sección “Desafíos”.

---

## Objetivo
Comprender los mecanismos para correr aplicaciones Docker multi-container con **Docker Compose**, usando máquinas virtuales con **Vagrant**.

## Herramientas
- Vagrant
- VirtualBox (u otro provider compatible)
- Docker Community Edition
- Docker Compose (plugin v2)
- Box: `bento/ubuntu-22.04`

---

## Estructura del repositorio (esperada)
.
├── Vagrantfile
├── scripts/
│   ├── provision-common.sh
│   └── provision-server.sh
├── compose/
│   ├── 01-nginx-redis/
│   │   ├── docker-compose.yml
│   │   ├── docker-compose.ports.yml
│   │   └── README.md
│   └── 02-ftp-compose/
│       ├── docker-compose.yml
│       └── README.md
└── docs/
    └── practica.pdf|docx (opcional, solo referencia)

---

## 0) Prerrequisitos en tu PC (host)
- Instalar Vagrant
- Instalar VirtualBox
- Tener habilitada la virtualización (BIOS/UEFI)

Opcional:
- Plugin: `vagrant-vbguest` (solo si lo necesitas)

---

## 1) Levantar máquinas (Vagrant)
Este repo crea 2 VMs:
- `clienteUbuntuDC` → IP `192.168.100.2`
- `servidorUbuntuDC` → IP `192.168.100.3`

### Comandos (host)
```bash
vagrant up
vagrant status
````

### Conectarte por SSH

```bash
vagrant ssh clienteUbuntuDC
# o
vagrant ssh servidorUbuntuDC
```

### Verificar red (dentro de cada VM)

```bash
ip a
ping -c 2 192.168.100.2
ping -c 2 192.168.100.3
```

---

## 2) Verificar Docker y Docker Compose (dentro de la VM)

En cualquiera de las VMs:

```bash
docker --version
docker compose version
```

Si el usuario no está en el grupo docker y requiere sudo:

```bash
sudo docker compose version
```

---

## 3) Parte Docker Compose básica (nginx + redis)

> Esta parte corre 2 servicios desde imágenes de Docker Hub: `nginx` y `redis`.

### 3.1 Crear carpeta de trabajo (dentro de la VM)

Recomendado hacerlo en `clienteUbuntuDC`:

```bash
cd ~
mkdir -p ~/dockerComposeTest
cd ~/dockerComposeTest
```

### 3.2 Usar el compose del repo

Opción A (recomendada): usar los archivos ya incluidos en este repo.

```bash
cd ~/repo/compose/01-nginx-redis
ls -la
```

Validar configuración:

```bash
docker compose config
```

Levantar contenedores:

```bash
sudo docker compose up -d
```

Verificar:

```bash
sudo docker ps
sudo docker compose ps
```

Bajar todo:

```bash
sudo docker compose down
```

---

## 4) Completar docker-compose con mapeo de puertos (9090:80)

En `compose/01-nginx-redis/docker-compose.ports.yml` se agrega:

* `9090:80/tcp` para `web (nginx)`

### Ejecutar (dentro de la VM)

```bash
cd ~/repo/compose/01-nginx-redis

# Usar compose con puertos
sudo docker compose -f docker-compose.ports.yml config
sudo docker compose -f docker-compose.ports.yml up -d
sudo docker compose -f docker-compose.ports.yml ps
```

Probar desde el host (tu PC) o desde la VM:

* Desde la VM:

```bash
curl -I http://localhost:9090
```

* Desde el host (si tu host puede enrutar a la IP privada de Vagrant):

```bash
curl -I http://192.168.100.2:9090
```

Bajar:

```bash
sudo docker compose -f docker-compose.ports.yml down
```

> Nota útil:
> Para recrear solo un servicio:

```bash
sudo docker compose up -d --no-deps --build web
```

---

## 5) Escalar un servicio (redis) a 4 instancias

```bash
cd ~/repo/compose/01-nginx-redis
sudo docker compose -f docker-compose.ports.yml up -d --scale database=4
sudo docker ps
sudo docker compose ps
```

Bajar:

```bash
sudo docker compose -f docker-compose.ports.yml down
```

---

## 6) Ejercicio: Servidor FTP con Docker Compose (NO es desafío)

> Se debe configurar un servidor FTP usando Docker Compose.
> Se sugiere usar imagen `fauria/vsftpd` (o `panubo/vsftpd`).

### 6.1 Preparar directorio de volumen (en servidorUbuntuDC)

Entrar a `servidorUbuntuDC`:

```bash
vagrant ssh servidorUbuntuDC
```

Crear directorio que se montará al contenedor:

```bash
sudo mkdir -p /home/vagrant/ftp
sudo chmod 777 /home/vagrant/ftp
```

Por precaución, apagar vsftpd local si existiera:

```bash
sudo service vsftpd stop || true
```

### 6.2 Levantar FTP con compose

Usar el compose del repo:

```bash
cd ~/repo/compose/02-ftp-compose
sudo docker compose config
sudo docker compose up -d
sudo docker compose ps
```

### 6.3 Pruebas rápidas

Ver que el puerto 21 está escuchando:

```bash
sudo ss -lntp | grep ':21' || true
sudo docker ps
```

Si tienes un cliente FTP instalado:

```bash
sudo apt-get update
sudo apt-get install -y ftp
ftp 127.0.0.1
```

### 6.4 Bajar todo

```bash
sudo docker compose down
```

---

## Limpieza general (si algo queda colgado)

```bash
sudo docker ps -aq | xargs -r sudo docker rm -f
sudo docker volume ls -q | xargs -r sudo docker volume rm
sudo docker network prune -f
```

---

## Notas importantes

* Este repo **NO incluye**:

  * CUDA + Python + Docker (aceleración GPU)
  * Docker dentro de LXD
  * Docker + Flask (repos externos de ejemplo)
  * Cualquier otra sección marcada como “Desafíos”

---

## Troubleshooting rápido

* “permission denied” con docker:

  * usa `sudo docker ...` o agrega tu usuario al grupo docker y reingresa:

    ```bash
    sudo usermod -aG docker $USER
    newgrp docker
    ```
* Compose no aparece:

  ```bash
  docker compose version
  ```

---

## Referencias

* Nginx image (Docker Hub)
* Redis image (Docker Hub)
* Documentación Docker Compose

````