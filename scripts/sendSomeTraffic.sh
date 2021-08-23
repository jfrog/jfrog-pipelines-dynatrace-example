#!/bin/bash

# This is a pipeline 'demo' script that sends a little traffic to the provided URL
# It is build specifically for the demo app within this repo
# It is intended to be run outside of a pipeline and can be stopped with 'ctrl-c'

URL=$1
echo "Calling $URL..."
for i in {1..1000}; 
  do
    echo "loop $i"
    curl -s -I -X GET "$URL/" | head -n 1 | cut -d$' ' -f2;
    curl -s -I -X GET "$URL/api/echo?text=Hello-World" | head -n 1 | cut -d$' ' -f2;
    curl -s -I -X GET "$URL/api/invoke?url=http://www.dynatrace.com" | head -n 1 | cut -d$' ' -f2;
    curl -s -I -X GET "$URL/api/invoke?url=http://blog.dynatrace.com" | head -n 1 | cut -d$' ' -f2;
done 
