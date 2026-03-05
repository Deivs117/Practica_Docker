#!/usr/bin/env bash
# provision-server.sh
# Aprovisionamiento específico para servidorUbuntu.
# Se ejecuta DESPUÉS de provision-common.sh.

set -euo pipefail

echo "==> [server] Preparando directorio FTP..."
mkdir -p /home/vagrant/ftp
chmod 777 /home/vagrant/ftp
chown vagrant:vagrant /home/vagrant/ftp

echo "==> [server] Deteniendo vsftpd local si estuviera activo..."
systemctl stop vsftpd 2>/dev/null || true
systemctl disable vsftpd 2>/dev/null || true

echo "==> provision-server.sh completado."
