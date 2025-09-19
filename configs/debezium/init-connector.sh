#!/bin/bash

# Script de inicialización para kafka-connect que configura el conector automáticamente

echo "Iniciando Kafka Connect..."

# Función para esperar a que Kafka Connect esté listo
wait_for_kafka_connect() {
    echo "Esperando a que Kafka Connect esté completamente listo..."
    while ! curl -f http://localhost:8083/ > /dev/null 2>&1; do
        echo "Kafka Connect no está listo aún, esperando..."
        sleep 5
    done
    echo "Kafka Connect está listo!"
}

# Función para configurar el conector
configure_connector() {
    echo "Configurando conector de Debezium..."
    
    # Usar variables de entorno con valores por defecto
    DB_HOST=${DB_HOST:-postgres-crediya}
    DB_PORT=${DB_PORT:-5432}
    DB_USER=${POSTGRES_USER:-crediya_user}
    DB_PASSWORD=${POSTGRES_PASSWORD:-crediya_password}
    DB_NAME=${POSTGRES_AUTH_DB:-crediya_auth}
    TOPIC_PREFIX=${DEBEZIUM_TOPIC_PREFIX:-crediya.auth}

    # Generar el JSON de configuración dinámicamente
    cat > /tmp/connector-config.json << EOF
{
  "name": "users-connector",
  "config": {
    "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
    "database.hostname": "${DB_HOST}",
    "database.port": "${DB_PORT}",
    "database.user": "${DB_USER}",
    "database.password": "${DB_PASSWORD}",
    "database.dbname": "${DB_NAME}",
    "database.server.name": "crediya_auth_server",
    "table.include.list": "public.users",
    "topic.prefix": "${TOPIC_PREFIX}",
    "plugin.name": "pgoutput",
    "slot.name": "debezium_slot",
    "publication.name": "dbz_publication",
    "key.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "key.converter.schemas.enable": false,
    "value.converter.schemas.enable": false,
    "transforms": "unwrap",
    "transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState",
    "transforms.unwrap.drop.tombstones": false,
    "transforms.unwrap.delete.handling.mode": "rewrite",
    "snapshot.mode": "initial"
  }
}
EOF

    echo "Configuración generada:"
    cat /tmp/connector-config.json

    # Intentar configurar el conector
    if curl -i -X POST -H 'Accept:application/json' -H 'Content-Type:application/json' \
            http://localhost:8083/connectors/ \
            -d @/tmp/connector-config.json; then
        echo "✅ Conector de Debezium configurado exitosamente!"
    else
        echo "❌ Error al configurar el conector. Revisar logs."
        return 1
    fi

    echo "Verificando estado del conector..."
    curl -s http://localhost:8083/connectors/
}

# Función principal que se ejecuta en background
configure_connector_async() {
    # Esperar un poco para que Kafka Connect termine de inicializar completamente
    sleep 30
    wait_for_kafka_connect
    configure_connector
}

# Si se pasa el argumento "configure", ejecutar la configuración en background
if [ "$1" = "configure" ]; then
    configure_connector_async &
    echo "Configuración del conector iniciada en background..."
fi

# Continuar con el comando original de Kafka Connect
exec /docker-entrypoint.sh start