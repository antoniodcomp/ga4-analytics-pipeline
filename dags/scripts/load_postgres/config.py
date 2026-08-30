import os

from sqlalchemy import create_engine
from sqlalchemy.engine import Engine


class DataLoaderConfig:


    def __init__(self):

        self.pg_user = os.getenv("POSTGRES_USER", "admin")
        self.pg_password = os.getenv("POSTGRES_PASSWORD", "admin123")

        self.pg_host = os.getenv("POSTGRES_HOST", "postgres_dw") 
        self.pg_port = os.getenv("POSTGRES_PORT", "5432")
        self.pg_db = os.getenv("POSTGRES_DB", "data_warehouse")

    def get_postgres_engine(self) -> Engine:
        db_url = f"postgresql+psycopg2://{self.pg_user}:{self.pg_password}@{self.pg_host}:{self.pg_port}/{self.pg_db}"
        engine = create_engine(db_url)

        return engine
