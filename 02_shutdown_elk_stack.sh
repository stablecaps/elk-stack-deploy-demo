#!/bin/bash


cd docker-elk || exit

docker-compose stop

echo -e "\n\nELK stack shutdown\n\n"

docker ps

echo ""


exit 0
