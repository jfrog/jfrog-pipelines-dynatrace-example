#!/bin/bash

# This is a pipeline 'demo' script that sends a little traffic to the provided URL
# It is build specifically for the demo app within this repo
# It is intended to be run outside of a pipeline and can be stopped with 'ctrl-c'

APP_IP=$(kubectl -n dev get service demoapp -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
APP_URL="http://${APP_IP}:8080"

echo "Calling $APP_URL..."
for i in {1..100000}; 
  do
    echo "loop $i"
    curl -s -I -X GET "$APP_URL/" | head -n 1 | cut -d$' ' -f2;
    curl -s -I -X GET "$APP_URL/api/echo?text=Hello-World" | head -n 1 | cut -d$' ' -f2;
    curl -s -I -X GET "$APP_URL/api/invoke?url=http://www.dynatrace.com" | head -n 1 | cut -d$' ' -f2;
    curl -s -I -X GET "$APP_URL/api/invoke?url=http://blog.dynatrace.com" | head -n 1 | cut -d$' ' -f2;
done 
