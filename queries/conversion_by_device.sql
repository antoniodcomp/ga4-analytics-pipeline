SELECT
    d.device,
    SUM(f.conversions) AS conversions,
    SUM(f.sessions) AS sessions,
    ROUND(
        SUM(f.conversions)::numeric / NULLIF(SUM(f.sessions), 0) * 100,
        2
    ) AS conversion_rate


FROM analytics.fact_ga4 AS f
JOIN analytics.dim_device AS d
    ON f.device_id = d.device_is
GROUP BY d.device
ORDER BY conversion_rate DESC;