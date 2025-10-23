import os, pathlib, sys
from datetime import datetime
import boto3, pandas as pd

BASE_URLS = {
  "yellow": "https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_{YYYY}-{MM}.parquet",
  "green": "https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_{YYYY}-{MM}.parquet",
}
BRONZE_BUCKET = os.getenv("S3_BUCKET_BRONZE", "bronze")
ENDPOINT = os.getenv("MINIO_ENDPOINT", "http://localhost:9000")
ACCESS_KEY = os.getenv("MINIO_ROOT_USER", "admin")
SECRET_KEY = os.getenv("MINIO_ROOT_PASSWORD", "admin12345")
REGION = os.getenv("S3_REGION", "us-east-1")

def month_parts(s: str):
    dt = datetime.strptime(s, "%Y-%m")
    return dt.strftime("%Y"), dt.strftime("%m")

def main(service: str, month: str):
    assert service in BASE_URLS, f"service must be one of {list(BASE_URLS)}"
    YYYY, MM = month_parts(month)
    url = BASE_URLS[service].replace("{YYYY}", YYYY).replace("{MM}", MM)
    local_dir = pathlib.Path("data/raw") / service / YYYY / MM
    local_dir.mkdir(parents=True, exist_ok=True)
    local_file = local_dir / f"{service}_tripdata_{YYYY}-{MM}.parquet"
    print(f"Downloading {url}")
    df = pd.read_parquet(url)
    df.to_parquet(local_file, index=False)
    key = f"nyc_tlc/{service}/{YYYY}/{MM}/{local_file.name}"
    print(f"Uploading to s3://{BRONZE_BUCKET}/{key}")
    s3 = boto3.client("s3", endpoint_url=ENDPOINT,
                      aws_access_key_id=ACCESS_KEY, aws_secret_access_key=SECRET_KEY,
                      region_name=REGION)
    s3.upload_file(str(local_file), BRONZE_BUCKET, key)
    print("Done.")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python pipelines/seed_nyc_tlc.py <yellow|green> <YYYY-MM>")
        sys.exit(1)
    main(sys.argv[1], sys.argv[2])