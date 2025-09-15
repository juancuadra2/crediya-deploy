# Guía de Instalación

Esta guía te ayudará a instalar y levantar la infraestructura base del proyecto usando Docker Compose. Incluye bases de datos PostgreSQL, Kafka, Zookeeper, Debezium para CDC, y herramientas de monitoreo.

## Requisitos previos

- Docker y Docker Compose instalados en tu máquina.
- Puertos 5432, 5433, 9092, 9101, 8090, 8083 disponibles.

## Pasos de instalación

1. **Clona el repositorio:**
	```bash
	git clone <URL_DEL_REPOSITORIO>
	cd microservices-cqrs-eda
	```

2. **Levanta la infraestructura base:**
	```bash
	docker compose up -d
	```
	Esto iniciará los siguientes servicios:
	- PostgreSQL (dos instancias: crediya_auth y crediya_requests)
	- Zookeeper
	- Kafka
	- Kafka UI (interfaz web para monitorear Kafka)
	- Debezium Kafka Connect (CDC)

3. **Verifica el estado de los servicios:**
	```bash
	docker compose ps
	```
	Puedes acceder a Kafka UI en [http://localhost:8090](http://localhost:8090)

## Inicialización de bases de datos

Las bases de datos se inicializan automáticamente usando los scripts SQL ubicados en `configs/postgres/`.

## Personalización y microservicios

Para agregar microservicios, descomenta y ajusta las secciones correspondientes en el archivo `docker-compose.yml`.

## Apagar la infraestructura

Para detener y eliminar los contenedores:
```bash
docker compose down
```

---

## Pruebas del Sistema CDC

Para realizar pruebas manuales del sistema Change Data Capture (CDC) y verificar que los cambios de usuarios se envían correctamente a Kafka, consulta la [Guía de Pruebas Manuales CDC](./GUIA_PRUEBAS_MANUALES_CDC.md).

---

Para más detalles, consulta los archivos de configuración en la carpeta `configs/`.

## Limpiar el ambiente completamente

Si necesitas eliminar todos los contenedores, volúmenes y redes creados por Docker Compose para empezar desde cero, ejecuta:

```bash
docker compose down --volumes --remove-orphans
```

Esto eliminará los contenedores, los volúmenes de datos y cualquier red huérfana asociada al proyecto.

Si deseas eliminar también las imágenes creadas (no recomendando salvo que sea necesario):
```bash
docker system prune -a
```
