SHELL := /bin/bash
ENV_FILE := .env
include $(ENV_FILE)
export $(shell sed -n -e 's/\r//g' -e 's/=.*//p' $(ENV_FILE))

.PHONY: up down logs superset-init seed duckdb-init

up:
	docker compose up -d --build

logs:
	docker compose logs -f --tail=100

superset-init:
	docker exec -it $$(docker compose ps -q superset) bash /app/superset-init.sh

seed:
	@if [ -z "$$SERVICE" ] || [ -z "$$MONTH" ]; then \
		echo "Usage: make seed SERVICE=yellow MONTH=2023-01"; exit 2; \
	fi
	python -m pip install -r requirements.txt >/dev/null
	python pipelines/seed_nyc_tlc.py $$SERVICE $$MONTH

duckdb-init:
	mkdir -p data
	python - <<'PY'
import duckdb, os
os.makedirs('data', exist_ok=True)
db = duckdb.connect('data/warehouse.duckdb'); db.close()
print('DuckDB ready at data/warehouse.duckdb')
PY
	export S3_REGION=$(S3_REGION) MINIO_ROOT_USER=$(MINIO_ROOT_USER) MINIO_ROOT_PASSWORD=$(MINIO_ROOT_PASSWORD); \
	duckdb data/warehouse.duckdb -c ".read sql/init_duckdb.sql"

down:
	docker compose down -v