WITH months AS (
     SELECT DISTINCT EXTRACT(MONTH FROM tpep_pickup_datetime) as month
     FROM {{ ref('transform')}}
)

SELECT COUNT(*) as nb_month
FROM months
HAVING nb_month <> 12