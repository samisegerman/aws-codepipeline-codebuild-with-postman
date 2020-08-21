#!/usr/bin/env bash

#This shell script updates Postman environment file with the API Gateway URL created
# via the api gateway deployment

echo "Running update-postman-env-file.sh"

api_gateway_url=`aws cloudformation describe-stacks \
  --stack-name matillion-api-stack \
  --query "Stacks[0].Outputs[*].{OutputValueValue:OutputValue}" --output text`

echo "API Gateway URL:" ${api_gateway_url}

jq -e --arg apigwurl "$api_gateway_url" '(.values[] | select(.key=="apigw-root") | .value) = $apigwurl' \
  MatillionAPIEnvironment.postman_environment.json > MatillionAPIEnvironment.postman_environment.json.tmp \
  && cp MatillionAPIEnvironment.postman_environment.json.tmp MatillionAPIEnvironment.postman_environment.json \
  && rm MatillionAPIEnvironment.postman_environment.json.tmp

echo "Updated MatillionAPIEnvironment.postman_environment.json"

cat MatillionAPIEnvironment.postman_environment.json