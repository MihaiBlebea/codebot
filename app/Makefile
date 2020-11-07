# setup: frontend docs backend

local:
	export HTTP_PORT=8081 &&\
	export SLACK_TOKEN=T01ECUVCAMN/B01ED2FCHJL/yWVRxJ8MGo0cyEXJD8BXqBxM &&\
	export WITAI_TOKEN=RSO37RX6O2NT3NCQWYF5CET4IJENJFCO &&\
	mix run --no-halt

docker-up:
	docker-compose build &&\
	docker-compose up -d

docker-down:
	docker-compose stop &&\
	docker-compose rm

docs:
	mix docs