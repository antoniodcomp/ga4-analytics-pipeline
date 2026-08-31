SELECT
    date,
    SUM(sessions) AS sessions,
    SUM(active_users) AS active_users,
    SUM(total_users) AS total_users
FROM analytics.fact_ga4
GROUP BY date
ORDER BY date;