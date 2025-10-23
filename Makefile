default: help

.PHONY: help

##@ general
help: ## Show this help message.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ build
deploy: ## Build and deploy the application.
	docker compose up -d --remove-orphans --build

migrate: ## Run database migrations.
	docker compose run server rails db:migrate

seed: ## Seed the database.
	docker compose run server rails db:seed

sync: ## Sync the application to the server
	rsync -av -e "ssh" --exclude='node_modules' --exclude='.git' --exclude='*.log' --exclude='.tmp' --exclude='tmp' --exclude='data' . worktools_server_new:~/worktools

connect: ## Connect to the server
	ssh worktools_server_new

replant:
	docker compose run server rails db:seed:replant

dangling:
	docker rmi -f $(docker images -f "dangling=true" -q)

pass: ## user = User.find_by(email: '') ; user.password = '' ; user.password_confirmation = '' ; user.save
	docker exec -it worktools-server-1 bash -c "RAILS_ENV=production bundle exec rails console"

cache: ## Clear the cache
	docker builder prune

load-test:
	python3 -m locust -f locustfile.py --host=http://185.11.167.156/

backup:
		rsync -av -e "ssh" worktools_server_new:~/worktools/data ./databackup
		rsync -av -e "ssh" worktools_server_new:~/worktools/storage ./databackup

backup-full: ## Complete backup of database and files
	mkdir -p ./databackup/$(shell date +%Y%m%d_%H%M%S)
	rsync -av -e "ssh" worktools_server_new:~/worktools/data ./databackup/$(shell date +%Y%m%d_%H%M%S)/
	rsync -av -e "ssh" worktools_server_new:~/worktools/storage ./databackup/$(shell date +%Y%m%d_%H%M%S)/

restore:
		# rsync -av -e "ssh" ./databackup/data/* worktools_server_new:~/worktools/data

parent:
	docker exec -it worktools-server-1 bash -c "RAILS_ENV=production bundle exec rake db:create_parents"

check_emails:
	docker exec -it worktools-server-1 bash -c "RAILS_ENV=production bundle exec rake db:collect_sorted_ids_and_emails"

flags:
	docker exec -it worktools-server-1 bash -c "RAILS_ENV=production bundle exec rake users:find_learners_without_flags"

attendance:
	docker exec -it worktools-server-1 bash -c "RAILS_ENV=production bundle exec rake attendances:delete_attendances"

personalized:
	docker exec -it worktools-server-1 bash -c "RAILS_ENV=production bundle exec rake reports:correct_personalized"

exam_dates:
	docker exec -it worktools-server-1 bash -c "RAILS_ENV=production bundle exec rake exam_dates:create_igcse_dates"

notify_error_exam_dates:
	docker exec -it worktools-server-1 bash -c "RAILS_ENV=production bundle exec rake timelines:notify_error_exam_dates"

send_unread_notifications:
	docker exec -it worktools-server-1 bash -c "RAILS_ENV=production bundle exec rake notifications:send_unread_notifications"

report_activity:
	docker exec -it worktools-server-1 bash -c "RAILS_ENV=production bundle exec rails db:create_missing_report_activities"

send_notification:
	docker exec -it worktools-server-1 bash -c "RAILS_ENV=production bundle exec rake notifications:send_notifications"

check_parent_kids:
	docker exec -it worktools-server-1 bash -c "RAILS_ENV=production bundle exec rake db:check_parent_kids"

ensure_report_knowledges:
	docker exec -it worktools-server-1 bash -c "RAILS_ENV=production bundle exec rake db:ensure_report_knowledges"

create_cm:
	docker exec -it worktools-server-1 bash -c "RAILS_ENV=production bundle exec rake db:create_cms"

delete_usertopics:
	docker exec -it worktools-server-1 bash -c "RAILS_ENV=production bundle exec rake user_topics:dedupe"

send_journey_emails:
	docker exec -it worktools-server-1 bash -c "RAILS_ENV=production bundle exec rake db:send_journey_emails"

set_report_parent:
	docker exec -it worktools-server-1 bash -c "RAILS_ENV=production bundle exec rake db:set_report_parent"

update_users:
	docker exec -it worktools-server-1 bash -c "RAILS_ENV=production bundle exec rake update_users_from_csv"

create_exam_enrolls:
	docker exec -it worktools-server-1 bash -c "RAILS_ENV=production bundle exec rake exam_enrolls:create"

update_exam_enroll_data:
	docker exec -it worktools-server-1 bash -c "RAILS_ENV=production bundle exec rake exam_enrolls:update_exam_enroll_data"

create_exam_finances:
	docker exec -it worktools-server-1 bash -c "RAILS_ENV=production bundle exec rake exam_finance:create_for_all"

update_timelines:
	docker exec -it worktools-server-1 bash -c "RAILS_ENV=production bundle exec rake timelines:simulate_update"

sync_moodle_users:
	docker exec -it worktools-server-1 bash -c "RAILS_ENV=production bundle exec rake moodle:sync_user_ids"

recreate_moodle_topics: ## Delete all moodle topics and recreate them from API
	docker exec -it worktools-server-1 bash -c "RAILS_ENV=production bundle exec rake moodle:recreate_topics"

recreate_moodle_timelines_by_id:
docker exec -it worktools-server-1 bash -c "RAILS_ENV=production bundle exec rake moodle:recreate_topics_by_ids"
