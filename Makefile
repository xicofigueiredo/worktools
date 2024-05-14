default: help

.PHONY: help

##@ general
help: ## Show this help message.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ build
deploy: ## Build and deploy the application.
	docker compose	 up -d --remove-orphans --build

migrate: ## Run database migrations.
	docker compose run server rails db:migrate

seed: ## Seed the database.
	docker compose run server rails db:seed

sync: ## Sync the application to the server
	rsync -av -e "ssh" --exclude='.git' --exclude='*.log' --exclude='.tmp' --exclude='tmp' --exclude='data' . worktools_server:~/worktools

connect: ## Connect to the server
	ssh worktools_server

replant:
	docker compose run server rails db:seed:replant

dangling:
	docker rmi -f $(docker images -f "dangling=true" -q)

pass: ## user = User.find_by(email: '') ; user.password = '' ; user.password_confirmation = '' ; user.save
	docker exec -it worktools-server-1 bash -c "RAILS_ENV=production bundle exec rails console"

cache: ## Clear the cache
	docker builder prune

load-test:
	python3 -m locust -f locustfile.py --host=http://worktools.site
