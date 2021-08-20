up:
	docker-compose up -d
start-pg:
	docker-compose start postgres 
down:
	docker-compose down
stop:
	docker-compose stop
restart:
	docker-compose restart
reset:
	make down; sleep 5; make up; sleep 10; make i-tender; sleep 5; make r-connector
upp:
	make up; sleep 10; make i-tender; sleep5; make r-connector
log:
	docker-compose logs -f
i-tender:
	docker exec -i cdc_postgres psql -U postgres tender < ~/Code/Komodo/k8s-config/sql/tender.sql
i-chat:
	docker exec -i cdc_postgres psql -U postgres chat < ~/Code/Komodo/k8s-config/sql/chat.sql
i-account:
	docker exec -i cdc_postgres psql -U postgres account < ~/Code/Komodo/k8s-config/sql/account.sql
e-tender:
	docker exec -it cdc_postgres bash
d-tender:
	docker-compose rm -s -v postgres 
c-tender:
	pgcli postgres://postgres:password@localhost:5432/tender
r-connector:
	curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/connectors/ -d @postgresql-connect.json
d-connector:
	curl -X DELETE http://localhost:8083/connectors/tender3
c-connector:
	curl -H "Accept:application/json" localhost:8083/connectors/
c-error:
	curl -H "Accept:application/json" localhost:8083/connector-plugins/io.debezium.connector.postgresql.PostgresConnector/config/validate | json_pp pretty,canonical
consume-kafka:
	docker exec cdc_kafka bin/kafka-console-consumer.sh --bootstrap-server kafka:9092 --topic postgres.public.data --from-beginning | jq
list-kafka-consumer:
	docker exec cdc_kafka bin/kafka-consumer-groups.sh --list --bootstrap-server kafka:9092
