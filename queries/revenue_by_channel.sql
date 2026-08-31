SELECT
    ch.channel,
    SUM(f.total_revenue) AS total_revenue
FROM analytics.fact_ga4 AS f
JOIN analytics.dim_Channel AS ch
    ON f.channel_id = ch.channel_id
GROUP BY ch.channel
ORDER BY total_revenue DESC;