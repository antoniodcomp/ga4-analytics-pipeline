from config import DataLoaderConfig
from extract import Extract
from load import LoadToWareHouse


def main():

    config = DataLoaderConfig()

    extract = Extract(prefix="/opt/airflow/data/raw/ga4/ga4_data.parquet")

    dataFrame = extract.extract_to_dataFrame()

    engine = config.get_postgres_engine()

    loader = LoadToWareHouse(df=dataFrame, engine=engine, sql_path="/opt/airflow/sql/bronze/ga4_raw.sql")

    loader.create_table()
    loader.insert_to_dataWarehouse()

    print("Dados carregados no PostgreSQL com sucesso.")


if __name__ == "__main__":
    main()