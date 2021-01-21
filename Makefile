.PHONY: build
build:
	@docker-compose build --pull --memory 4G

.PHONY: install
install: build start install-libraries

.PHONY: install-libraries
install-libraries:
	@docker-compose exec php-fpm composer install

.PHONY: create-database
create-database:
	@docker-compose exec php-fpm bin/console doctrine:database:drop --if-exists --force
	@docker-compose exec php-fpm bin/console doctrine:database:create
	@docker-compose exec php-fpm bin/console doctrine:schema:create

.PHONY: start
start:
	@docker-compose up -d

.PHONY: stop
stop:
	@docker-compose down

.PHONY: restart
restart: stop start

.PHONY: behat
behat:
	@docker-compose exec php-fpm vendor/bin/behat
