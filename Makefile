THIS_FILE := $(lastword $(MAKEFILE_LIST))
.PHONY: help build clean-build up start down destroy stop restart logs logs-api ps login-timescale login-api db-shell
help:
	make -pRrq  -f $(THIS_FILE) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

.DEFAULT_GOAL := help

up: ## pull and create containers
	docker-compose up -d $(c)

down: ## stop and remove running containers
	docker-compose down $(c)

destroy: ## stop and remove running containers and volumes
	docker-compose down -v $(c)

start: ## start containers
	docker-compose start $(c)

stop: ## stop running containers
	docker-compose stop $(c)

restart: ## stop and start running containers
	docker-compose stop $(c)
	docker-compose up -d $(c)

logs:  ## get logs of the container
	docker-compose logs --tail=100 -f $(c)

logs-api: ## get logs of the container api service
	docker-compose logs --tail=100 -f api

ps:  ## list all the running containers
	docker-compose ps

login-timescale:
	docker-compose exec timescale /bin/bash

login-api:
	docker-compose exec api /bin/bash

mongo-shell: ## start mongo shell
	docker-compose exec timescale mongo

build: ## build containers
	docker-compose build

clean-build: ## build containers without accepting cached data
	docker-compose build --no-cache

debug: ## debug the service
	docker-compose -f "docker-compose.debug.yaml" up -d --build

debug-down: ## debug the service
	docker-compose -f "docker-compose.debug.yaml" down -v $(c)