up:
	docker-compose up -d
down:
	docker-compose down
stop:
	docker-compose stop
log:
	docker-compose logs -f
i-tender:
	docker exec -i cdc_postgres psql -U user tender < ~/Code/Komodo/sql/tender.sql
c-tender:
	pgcli postgres://user:password@localhost:5432/tender
r-connector:
	curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/connectors/ -d @postgresql-connect.json
d-connector:
	curl -X DELETE http://localhost:8083/connectors/tender-table
c-connector:
	curl -H "Accept:application/json" localhost:8083/connectors/
consume-kafka:
	docker exec cdc_kafka bin/kafka-console-consumer.sh --bootstrap-server kafka:9092 --topic postgres.public.data --from-beginning | jq
list-kafka-consumer:
	docker exec cdc_kafka bin/kafka-consumer-groups.sh --list --bootstrap-server kafka:9092
