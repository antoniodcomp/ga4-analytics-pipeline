SELECT
    date,
    country,
    session_default_channel_group,
    device_category,
    active_users,
    sessions,
    total_users,
    conversions,
    total_revenue
FROM bronze.ga4_raw
