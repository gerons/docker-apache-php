# docker-apache-php

Plantilla Docker para crear una imagen donde depurar aplicaciones PHP con Apache, Xdebug y soporte para múltiples bases de datos.

## Imagen base

- `php:8.2-apache`

## Extensiones PHP incluidas

| Extensión | Versión | Descripción |
|-----------|---------|-------------|
| gd | - | Procesamiento de imágenes (con freetype y jpeg) |
| pgsql | - | Conector nativo PostgreSQL |
| pdo_pgsql | - | PDO para PostgreSQL |
| mysqli | - | Conector nativo MySQL/MariaDB |
| pdo_mysql | - | PDO para MySQL/MariaDB |
| curl | - | Cliente HTTP |
| redis | 5.3.7 | Cliente Redis (PECL) |
| xdebug | 3.2.0 | Depurador PHP (PECL) |

## Configuración PHP

| Directiva | Valor |
|-----------|-------|
| `upload_max_filesize` | 20M |
| `post_max_size` | 25M |
| `max_execution_time` | 300s |
| `max_input_time` | 300s |
| `memory_limit` | 256M |

## Configuración Apache

- Módulo `mod_rewrite` habilitado
- `AllowOverride All` activado (soporte para `.htaccess`)
- Puerto expuesto: `80`

## Xdebug

La configuración de Xdebug se encuentra en `xdebug.ini`:

- **Modo:** `debug`
- **Inicio automático:** `yes` (se activa con cada request)
- **Host del cliente:** `host.docker.internal`
- **Puerto:** `9003`

### Deshabilitar Xdebug

Se puede deshabilitar Xdebug en tiempo de ejecución mediante la variable de entorno `XDEBUG_ENABLED`. Si su valor es `0`, el archivo `xdebug.ini` se elimina al iniciar el contenedor (mediante `start-container.sh`).

```yaml
# En docker-compose.yml
environment:
  XDEBUG_ENABLED: 0
```

## Uso con docker-compose

Esta imagen no copia el código fuente de la aplicación; los archivos deben montarse como volumen desde `docker-compose.yml`:

```yaml
services:
  php:
    build: .
    ports:
      - "80:80"
    volumes:
      - ./src:/var/www/html
    environment:
      XDEBUG_ENABLED: 1
    command: /var/www/html/start-container.sh
```

## Construir la imagen

```bash
docker build -t mi-app-php .
```
