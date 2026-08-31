SELECT
    f.date,
    c.country,
    ch.channel,
    d.device,
    f.active_users,
    f.conversions,
    f.total_revenue

FROM analytics.fact_ga4 AS f
JOIN analytics.dim_country AS c
    ON f.country_id = c.country_id
JOIN analitycs.dim_channel AS ch
    ON f.channel_id = ch.channel_id
JOIN analytics.dim_device AS d
    ON f.device_id = d.device_id
ORDER BY f.date