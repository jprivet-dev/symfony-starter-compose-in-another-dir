#
# COLORS
#

RESET     = "\\033[0m"
BLUE      = "\\033[34m"
GREEN     = "\\033[32m"
RED       = "\\033[31m"
YELLOW    = "\\033[33m"
UNDERLINE = "\\033[4m"

#
# EXECUTABLES (LOCAL)
#

USER_ID  = $(shell id -u)
GROUP_ID = $(shell id -g)

COMPOSE_V2 := $(shell docker compose version 2> /dev/null)

ifndef COMPOSE_V2
$(error Docker Compose CLI plugin is required but is not available on your system)
endif

APP_DIR      = app
APP_PATH     = $(PWD)/$(APP_DIR)
DOCKER_DIR   = docker
DOCKER_PATH  = $(PWD)/$(DOCKER_DIR)
DOCKER_REP   = git@github.com:jprivet-dev/symfony-docker.git
PROJECT_NAME = $(shell basename $(CURDIR))
SERVER_NAME  = $(PROJECT_NAME).localhost

COMPOSE_BASE     = $(DOCKER_DIR)/compose.yaml
COMPOSE_OVERRIDE = $(DOCKER_DIR)/compose.override.yaml
COMPOSE          =\
	APP_PATH=$(APP_PATH) DOCKER_PATH=$(DOCKER_PATH) SERVER_NAME=$(SERVER_NAME) \
	docker compose \
	-p $(PROJECT_NAME) -f $(COMPOSE_BASE) -f $(COMPOSE_OVERRIDE)

CONTAINER_PHP = $(COMPOSE) exec php
PHP           = $(CONTAINER_PHP) php
COMPOSER      = $(CONTAINER_PHP) composer
CONSOLE       = $(PHP) bin/console

ALIASES_SOURCE = scripts/_aliases.source.sh

## — 🐳 🎵 THE SYMFONY STARTER MAKEFILE 🎵 🐳 —————————————————————————————————

# Print self-documented Makefile:
# $ make
# $ make help

.DEFAULT_GOAL = help
.PHONY: help
help: ## Print self-documented Makefile
	@grep -E '(^[.a-zA-Z_-]+[^:]+:.*##.*?$$)|(^#{2})' Makefile \
	| awk 'BEGIN {FS = "## "}; \
		{ \
			split($$1, line, ":"); \
			targets=line[1]; \
			description=$$2; \
			if (targets == "##") { \
				# --- space --- \
				printf "\033[33m%s\n", ""; \
			} else if (targets == "" && description != "") { \
				# --- title --- \
				printf "\033[33m\n%s\n", description; \
			} else if (targets != "" && description != "") { \
				# --- target, alias, description --- \
				split(targets, parts, " "); \
				target=parts[1]; \
				alias=parts[2]; \
				printf "\033[32m  %-26s \033[34m%-2s \033[0m%s\n", target, alias, description; \
			} \
		}'
	@echo

## — PROJECT 🚀 ———————————————————————————————————————————————————————————————

.PHONY: init
init: confirm_continue clone build up_d permissions info ## Generate a fresh Symfony application, with the Docker configuration in a parallel directory [y/N]

.PHONY: start
start: up_d info ## Start the project (implies detached mode)

.PHONY: stop
stop: down ## Stop the project

PHONY: info
info: ## Show info
	@echo "Go on: $(GREEN)https://$(SERVER_NAME)/$(RESET)"

## — SYMFONY 🎵 ———————————————————————————————————————————————————————————————

.PHONY: symfony
symfony sf: ## Run Symfony - $ make symfony [p=<params>] - Example: $ make symfony p=cache:clear
	@$(eval p ?=)
	$(CONSOLE) $(p)

.PHONY: cc
cc: ## Clear the cache
	$(CONSOLE) cache:clear

.PHONY: cw
cw: ## Warm up an empty cache
	$(CONSOLE) cache:warmup --no-debug

.PHONY: about
about: ## Display information about the current project
	$(CONSOLE) about

.PHONY: dotenv
dotenv: ## Lists all dotenv files with variables and values
	$(CONSOLE) debug:dotenv

.PHONY: dumpenv
dumpenv: ## Generate .env.local.php (PROD)
	$(COMPOSER) dump-env prod

## — PHP 🐘 ———————————————————————————————————————————————————————————————————

.PHONY: php
php: ## Run PHP - $ make php [p=<params>]
	@$(eval p ?=)
	$(PHP) $(p)

.PHONY: php_sh
php_sh: ## Connect to the PHP container
	$(CONTAINER_PHP) sh

.PHONY: php_version
php_version: ## PHP version number
	$(PHP) -v

.PHONY: php_modules
php_modules: ## Show compiled in modules
	$(PHP) -m

## — COMPOSER 🧙 ——————————————————————————————————————————————————————————————

.PHONY: composer
composer: ## Run composer - $ make composer [p=<param>] - Example: $ make composer p="require --dev phpunit/phpunit"
	@$(eval p ?=)
	$(COMPOSER) $(p)

.PHONY: composer_version
composer_version: ## Composer version
	$(COMPOSER) --version

.PHONY: composer_validate
composer_validate: ## Validate composer.json and composer.lock
	$(COMPOSER) validate --strict --lock

##

.PHONY: composer_install
composer_install: ## Install packages using composer
	$(COMPOSER) install

.PHONY: composer_install@prod
composer_install@prod: ## Install packages using composer (PROD)
	$(COMPOSER) install --verbose --prefer-dist --no-progress --no-interaction --no-dev --optimize-autoloader

.PHONY: composer_update
composer_update: ## Update packages using composer
	$(COMPOSER) update

.PHONY: composer_update@prod
composer_update@prod: ## Update packages using composer (PROD)
	$(COMPOSER) update --verbose --prefer-dist --no-progress --no-interaction --no-dev --optimize-autoloader

## — SYMFONY DOCKER 🎵 🐳 —————————————————————————————————————————————————————

PHONY: clone
clone: ## Clone Symfony Docker (forked version)
ifeq ($(wildcard $(DOCKER_DIR)),)
	@printf "Clone Symfony Docker (next branch)\n"
	git clone $(DOCKER_REP) $(DOCKER_DIR) -b next
else
	@printf "Symfony Docker already cloned\n"
endif

## — DOCKER 🐳 ————————————————————————————————————————————————————————————————

.PHONY: up
up: ## Start the container
	$(COMPOSE) up --pull always

.PHONY: up_d
up_d: ## Start the container (wait for services to be running|healthy - detached mode)
	$(COMPOSE) up --pull always -d --wait

.PHONY: down
down: ## Stop the container
	$(COMPOSE) down --remove-orphans

.PHONY: build
build: ## Build or rebuild services
	$(COMPOSE) build --no-cache

.PHONY: logs
logs: ## See the container’s logs
	$(COMPOSE) logs -f

##

.PHONY: docker_stop_all
docker_stop_all: confirm_continue ## Stop all running containers [y/N]
	docker stop $$(docker ps -a -q)

.PHONY: docker_remove_all
docker_remove_all: confirm_continue ## Remove all stopped containers [y/N]
	docker rm $$(docker ps -a -q)

## — TROUBLESHOOTING 😵‍️ ———————————————————————————————————————————————————————

.PHONY: permissions
permissions: ## Run it if you cannot edit some of the project files on Linux (https://github.com/dunglas/symfony-docker/blob/main/docs/troubleshooting.md)
	$(COMPOSE) run --rm php chown -R $(USER_ID):$(GROUP_ID) .

## — INTERNAL 🚧‍️ ——————————————————————————————————————————————————————————————

PHONY: confirm_continue
confirm_continue: ## Display a confirmation before continuing [y/N]
	@$(eval yes_by_default ?=) # Default ‘yes’ answer
	@if [ "$${yes_by_default}" = "true" ]; then exit 0; fi; \
	printf "$(GREEN)Do you want to continue?$(RESET) [$(YELLOW)y/N$(RESET)]: " && read answer && [ $${answer:-N} = y ]

