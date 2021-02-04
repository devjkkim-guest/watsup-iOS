#!/bin/bash

set -euo pipefail

BIGREEN='\033[1;92m'
NC='\033[0m'

function log {
  echo -e "\n${BIGREEN}${1}${NC}"
}

log "[1/6] Teardown existing services"
docker-compose down -v --remove-orphans

log "[2/6] Check for updates"
docker-compose pull

log "[3/6] Start Database"
docker-compose up -d mysql

log "[4/6] Wait Database port"
docker-compose run --rm prod /tools/wait-for-it.sh mysql:3306 -t 30

log "[5/6] Migrate Database"
docker-compose run --rm prod ./manage.py db upgrade

log "[6/6] Start API"
docker-compose up $@ prod
