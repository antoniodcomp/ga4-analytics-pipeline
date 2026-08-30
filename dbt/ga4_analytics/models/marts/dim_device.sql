WITH devices AS (

    SELECT DISTINCT
        device_category AS device
    FROM {{ ref('stg_ga4') }}
    WHERE device_category IS NOT NULL
)

SELECT
    ROW_NUMBER() OVER (ORDER BY device) AS device_id, device
FROM devices