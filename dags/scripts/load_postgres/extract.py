import pandas as pd

class Extract:

    def __init__(self, prefix: str):
        self.prefix = prefix


    def extract_to_dataFrame(self) -> pd.DataFrame:

        df = pd.read_parquet(self.prefix)

        return df