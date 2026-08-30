from airflow.sdk import DAG
from airflow.providers.standard.operators.bash import BashOperator

from datetime import datetime


with DAG(
    dag_id="ga4_pipeline",
    start_date=datetime(2026, 8, 30),
    schedule=None,
    catchup=False,
) as dag:

    extract_ga4 = BashOperator(
        task_id="extract_ga4",
        bash_command="python /opt/airflow/dags/scripts/extract_ga4.py",
    )