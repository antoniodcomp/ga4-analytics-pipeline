CREATE SCHEMA IF NOT EXISTS bronze;

CREATE TABLE IF NOT EXISTS bronze.ga4_raw (
    date DATE,
    country VARCHAR(100),
    session_default_channel_group VARCHAR(100),
    device_category VARCHAR(50),
    active_users INTEGER,
    sessions INTEGER,
    total_users INTEGER,
    conversions INTEGER,
    total_revenue NUMERIC

)