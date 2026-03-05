#!/usr/bin/env bash
# provision-common.sh
# Instala Docker CE y el plugin Docker Compose v2 en Ubuntu 22.04.
# Se ejecuta en AMBAS VMs (clienteUbuntu y servidorUbuntu).

set -euo pipefail

echo "==> Actualizando paquetes..."
apt-get update -y

echo "==> Instalando dependencias previas..."
apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release

echo "==> Añadiendo clave GPG y repositorio de Docker..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" \
  > /etc/apt/sources.list.d/docker.list

echo "==> Instalando Docker CE y plugin Compose..."
apt-get update -y
apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

echo "==> Añadiendo usuario vagrant al grupo docker..."
usermod -aG docker vagrant

echo "==> Habilitando y arrancando servicio Docker..."
systemctl enable docker
systemctl start docker

echo "==> Versiones instaladas:"
docker --version
docker compose version

echo "==> provision-common.sh completado."
