#! /bin/bash

AJUDA=$(cat <<-HEREDOC
Este script realiza o envio de métricas para o Newrelic, siga a sintaxe formalizada abaixo:

/bin/bash send_metrics_newrelic.sh API_KEY APP_ID NAME_METRIC VALUE NOME_ARQUIVO_LOG

Sendo:

API_KEY = key gerada no Newrelic para ser possível a interação via API.
APP_ID = ID referente à aplicação.
NAME_METRIC = Nome da métrica que está sendo enviada.
VALUE = Valor da métrica coletada.
NOME_ARQUIVO_LOG = O nome do arquivo de log. (não necessário .log no final).

Caso não seja passado o nome do arquivo para log, será criado com o APP_ID.

HEREDOC
)

API_KEY=$1

APP_ID=$2

NAME_METRIC="$3"

VALUE="$4"

if [ "$3" == "" ]; then
    ARQUIVO_LOG="log/send_metrics_\"$APP_ID\".log"
else
    ARQUIVO_LOG="log/\"$3\".log"

if [ "$API_KEY" == "" ] || [ "$API_KEY" == "-h" ] || [ "$API_KEY" == "--help" ] || [ "$APP_ID" == "" ] || [ "$APP_ID" == "-h" ] || [ "$APP_ID" == "--help" ]; then
    echo -e "$AJUDA\n"
    exit
fi

echo -e "\n\n" >> $ARQUIVO_LOG

curl -X POST "https://api.newrelic.com/v2/applications/${APP_ID}/metrics.json" \
     -H "X-Api-Key:${API_KEY}" -i \
     -H "Content-Type: application/json" \
     -d \
"{
  \"metric\": {
    \"application\": \"$APP_NAME\",
    \"name\": \"$NAME_METRIC\",
    \"value\": \"$VALUE\"
  }
}" | tee -a $ARQUIVO_LOG

echo -e "\n"
