# 01 – nginx + redis

Levanta dos servicios a partir de imágenes de Docker Hub:

| Servicio   | Imagen          | Descripción              |
|------------|-----------------|--------------------------|
| `web`      | `nginx:latest`  | Servidor web             |
| `database` | `redis:latest`  | Base de datos en memoria |

## Uso básico

```bash
# Levantar
sudo docker compose up -d

# Ver estado
sudo docker compose ps

# Bajar
sudo docker compose down
```

## Con mapeo de puertos (9090→80)

```bash
# Levantar con puertos
sudo docker compose -f docker-compose.ports.yml up -d

# Probar
curl -I http://localhost:9090

# Escalar redis a 4 instancias
sudo docker compose -f docker-compose.ports.yml up -d --scale database=4

# Bajar
sudo docker compose -f docker-compose.ports.yml down
```
