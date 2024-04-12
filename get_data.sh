#!/bin/bash

id=$(terraform output -raw rest_api_id)
url="http://${id}.execute-api.localhost.localstack.cloud:4566/test"
curl -X GET "${url}/first"
 
curl -X GET "${url}/second"  -H "Authorization: 946684800"