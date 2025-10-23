INSTALL httpfs; LOAD httpfs;
SET s3_region='${S3_REGION}';
SET s3_url='http://localhost:9000';
SET s3_access_key_id='${MINIO_ROOT_USER}';
SET s3_secret_access_key='${MINIO_ROOT_PASSWORD}';
SET s3_use_ssl=false;

CREATE SCHEMA IF NOT EXISTS bronze;
CREATE OR REPLACE VIEW bronze.yellow_trips_2023_01 AS
SELECT * FROM read_parquet('s3://bronze/nyc_tlc/yellow/2023/01/*.parquet');

SELECT count(*) AS row_count FROM bronze.yellow_trips_2023_01;