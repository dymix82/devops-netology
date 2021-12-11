#!/bin/bash
export VAULT_ADDR='https://localhost:8200'
export VAULT_TOKEN='token'
CERT_NAME='/etc/nginx/ssl/wildcard_example.cer'
KEY_NAME='/etc/nginx/ssl/wildcard_example.pem'
JSON_NAME='/tmp/wildcard_example.com.json'
VAULT_EXEC='vault write -format=json pki_int/issue/example-dot-com common_name=*.example.com ttl=720h'

enroll_ssl () {
    ${VAULT_EXEC}>${JSON_NAME}
    if [ ! -s $JSON_NAME ]; then   #Если файл пустой выходим, лучше просроченный сертификат чем никакой
        echo "Error"
        exit 0
    else
    echo "Enroll ssl certificate..."
    fi
    }
parse_json() {
  cat ${JSON_NAME} | jq -r '.data.private_key' > ${KEY_NAME}
  cat ${JSON_NAME} | jq -r '.data.certificate' > ${CERT_NAME}
  cat ${JSON_NAME} | jq -r '.data.ca_chain[]' >> ${CERT_NAME}
  rm ${JSON_NAME}
}
enroll_ssl
parse_json
sleep 2
systemctl restart nginx




