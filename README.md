# 🏙️ City Mobility & Air Quality Data Lakehouse

### 🚀 End-to-End Data Engineering Capstone Project  
A hands-on, modern **data lakehouse** built from scratch to learn and demonstrate real-world data engineering skills — using open-source tools.

---

## 🧠 Project Overview
This project simulates a real data engineering workflow:
- Ingest raw NYC taxi trip data (and later air-quality data)
- Store it in a **data lake** (MinIO – S3 compatible)
- Process and transform it through **DuckDB** and **dbt**
- Visualize insights in **Apache Superset**
- Orchestrate and validate data pipelines with **Prefect** and **Great Expectations**
- Eventually scale up to cloud or Databricks environments

---

## 🏗️ Architecture
[ NYC TLC API ] ---> [ Ingestion Script (Python) ]
|
v
[ MinIO (Bronze Zone) ]
|
v
[ DuckDB (Query + Transform) ]
|
v
[ Apache Superset Dashboard (Gold) ]


**Tools Used**
| Layer | Tool | Purpose |
|-------|------|----------|
| Storage | **MinIO (S3)** | Object storage for raw/silver/gold data |
| Compute | **DuckDB** | Local SQL engine for transformations |
| Orchestration | **Prefect** | Workflow scheduling (to be added) |
| Dashboard | **Apache Superset** | Visualization and analytics |
| Metadata | **Git + GitHub** | Version control & portfolio |
| Automation | **Makefile** | Simplified common commands |
