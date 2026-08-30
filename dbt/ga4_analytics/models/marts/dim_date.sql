WITH dates AS (


    SELECT DISTINCT
        date
    FROM {{ ref('stg_ga4') }}

)

SELECT 
    date,
    EXTRACT(YEAR FROM date)::INTEGER AS year,
    EXTRACT(MONTH FROM date)::INTEGER AS month,
    EXTRACT(DAY FROM date)::INTEGER AS day,
    EXTRACT(DOW FROM date)::INTEGER AS day_of_week,
    EXTRACT(QUARTER FROM date)::INTEGER AS quarter

FROM dates
