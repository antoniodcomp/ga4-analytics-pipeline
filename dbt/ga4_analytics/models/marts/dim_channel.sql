WITH channels AS (

    SELECT DISTINCT
        session_default_channel_group AS channel
    FROM {{ ref('stg_ga4') }}
    WHERE session_default_channel_group IS NOT NULL
)

SELECT
    ROW_NUMBER() OVER (ORDER BY channel) AS channel_id, channel
FROM channels