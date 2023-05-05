#! /bin/bash

AJUDA=$(cat <<-HEREDOC

Este script realiza o envio de métricas para o Newrelic, siga a sintaxe formalizada abaixo:

Usage:

  /bin/bash send_metrics.sh HOST_NAME NAME_METRIC VALUE

Params:

API_KEY = key gerada no Newrelic para ser possível a interação via API.
HOST_NAME = attribute host.name para utilizar como filtro nas metricas.
NAME_METRIC = Nome da métrica que está sendo enviada.
VALUE = Valor da métrica coletada.

HEREDOC
)

#sbws-prd
API_KEY="<<API_KEY>>"
TIMESTAMP=$(date +%s)
HOST_NAME="$1"
NAME_METRIC="$2"
VALUE="$3"

if [ -z $1 ] || [ $1 = "" ] || [ $1 = "--help" ]; then
    echo "$AJUDA\n"
    exit
fi


JSON_METRIC="[{
        \"metrics\":[{
            \"name\":\"$NAME_METRIC\",
            \"type\":\"gauge\",
            \"value\":$VALUE,
            \"timestamp\":$TIMESTAMP,
            \"attributes\":{\"host.name\":\"$HOST_NAME\"}
        }]
    }]"

echo $JSON_METRIC

curl -vvv -k -H "Content-Type: application/json" \
 -H "Api-Key: $API_KEY" \
 -X POST "https://metric-api.newrelic.com/metric/v1" \
 --data '$JSON_METRIC'
