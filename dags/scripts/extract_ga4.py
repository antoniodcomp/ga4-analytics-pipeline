import os
import pandas as pd
from google.analytics.data_v1beta import BetaAnalyticsDataClient
from google.analytics.data_v1beta.types import (
    DateRange,
    Dimension,
    Metric,
    RunReportRequest,
)


PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "../.."))

CREDENTIALS_PATH = os.path.join(
    PROJECT_ROOT,
    "credentials",
    "ga4-analytics-pipeline-507015-191168f82786.json"
)

os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = CREDENTIALS_PATH


PROPERTY_ID = "552066255"


client = BetaAnalyticsDataClient()



request = RunReportRequest(
    property=f"properties/{PROPERTY_ID}",

    dimensions=[
        Dimension(name="date"),
        Dimension(name="country"),
        Dimension(name="sessionDefaultChannelGroup"),
        Dimension(name="deviceCategory"),
    ],

    metrics=[
        Metric(name="activeUsers"),
        Metric(name="sessions"),
        Metric(name="totalUsers"),
        Metric(name="conversions"),
        Metric(name="totalRevenue"),
    ],

    date_ranges=[
        DateRange(
            start_date="7daysAgo", 
            end_date="today",
        ),
    ],
)

response = client.run_report(request)


rows = []

for row in response.rows:

    rows.append({
        "date": row.dimension_values[0].value,
        "country": row.dimension_values[1].value,
        "session_default_channel_group": row.dimension_values[2].value,
        "device_category": row.dimension_values[3].value,

        "active_users": row.metric_values[0].value,
        "sessions": row.metric_values[1].value,
        "total_users": row.metric_values[2].value,
        "conversions": row.metric_values[3].value,
        "total_revenue": row.metric_values[4].value,
    })



df = pd.DataFrame(rows)

output_dir = os.path.join(
    PROJECT_ROOT,
    "data",
    "raw",
    "ga4"
)


os.makedirs(output_dir, exist_ok=True)

output_path = os.path.join(output_dir, "ga4_data.parquet")

df.to_parquet(output_path, index=False)

print(f"Dados salvos em: {output_path}")

