WITH countries AS (

    SELECT DISTINCT
        country
    FROM {{ ref('stg_ga4') }}
    WHERE country IS NOT NULL
)

SELECT
    ROW_NUMBER() OVER (ORDER BY country) AS country_id, country
FROM countries