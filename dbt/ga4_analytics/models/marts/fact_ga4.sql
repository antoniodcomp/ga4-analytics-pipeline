SELECT
    d.date,

    c.country_id,
    ch.channel_id,
    dv.device_id,

    SUM(s.active_users) AS active_users,
    SUM(s.sessions) AS sessions,
    SUM(s.total_users) AS total_users,
    SUM(s.conversions) AS conversions,
    SUM(s.total_revenue) AS total_revenue

FROM {{ ref('stg_ga4') }} AS s

INNER JOIN {{ ref('dim_date' )}} AS d
    ON s.date = d.date

INNER JOIN {{ ref('dim_country') }} AS c
    ON s.country = c.country

INNER JOIN {{ ref('dim_channel') }} AS ch
    ON s.session_default_channel_group = ch.channel

INNER JOIN {{ ref('dim_device') }} AS dv
    ON s.device_category = dv.device


GROUP BY
    d.date,
    c.country_id,
    ch.channel_id,
    dv.device_id