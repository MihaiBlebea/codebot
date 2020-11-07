setup:
	cd ./deploy/terraform &&\
	terraform init &&\
	terraform plan &&\
	terraform apply -auto-approve

destroy:
	cd ./deploy/terraform &&\
	terraform destroy -auto-approve

docker-up:
	cd ./app &&\
	docker-compose build &&\
	docker-compose up -d

docker-down:
	cd ./app &&\
	docker-compose stop &&\
	docker-compose rm

docs:
	cd ./app &&\
	mix docs