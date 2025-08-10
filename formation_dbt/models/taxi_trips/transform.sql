-- Configuration du modèle :
-- - Création d'une table matérialisée en externe (fichier Parquet)
-- - Emplacement : output/trips_2024_transformed.parquet
-- - Format : parquet
{{ config(
    materialized='external',
    location='output/trips_2024_transformed.parquet', 
    format='parquet'
) }}


-- Étape 1 : Chargement des données sources depuis la table raw "row_yellow_tripdata"
--           et exclusion des colonnes VendorID et RatecodeID qui ne sont pas nécessaires pour l'analyse.
WITH source_data AS (
    SELECT * EXCLUDE (VendorID, RatecodeID)
    FROM {{ source('tlc_texi_trps', 'row_yellow_tripdata') }}
),


-- Étape 2 : Filtrage des données pour ne conserver que les trajets valides et cohérents.
filtered_data AS (
    SELECT * 
    FROM source_data
    WHERE passenger_count > 0                -- Exclut les trajets sans passager
      AND trip_distance > 0                  -- Exclut les trajets avec distance nulle ou négative
      AND total_amount > 0                    -- Exclut les trajets sans montant facturé ou négatifs
      AND tpep_pickup_datetime < tpep_dropoff_datetime  -- Exclut les trajets où l'heure de départ est après l'arrivée
      AND store_and_fwd_flag = 'N'            -- Conserve uniquement les trajets transmis directement (pas stockés en mémoire)
      AND tip_amount >= 0                     -- Supprime les valeurs de pourboire négatives
      AND payment_type IN (1, 2)               -- Ne garde que les paiements en carte (1) ou en cash (2)
),


-- Étape 3 : Transformation des données :
-- - Calcul de la durée du trajet en minutes
-- - Normalisation des types de données (ex. passenger_count)
-- - Traduction des codes de paiement en valeurs lisibles
-- - Sélection des colonnes pertinentes
transformed_data AS (
    SELECT 
        tpep_pickup_datetime,
        tpep_dropoff_datetime,
        DATE_DIFF('minute', tpep_pickup_datetime, tpep_dropoff_datetime) AS trip_duration_minutes,  -- Calcul de la durée en minutes
        trip_distance,
        CAST(passenger_count AS BIGINT) AS passenger_count,  -- Conversion du nombre de passagers en entier
        CASE 
            WHEN payment_type = 1 THEN 'Credit card'
            WHEN payment_type = 2 THEN 'Cash'
        END AS payment_method,  -- Traduction du code de paiement en texte
        store_and_fwd_flag,
        PULocationID,
        DOLocationID,
        fare_amount,
        total_amount,
        tip_amount,
        tolls_amount,
        improvement_surcharge,
        congestion_surcharge,
        extra,
        mta_tax,
        Airport_fee
    FROM filtered_data
), 


-- Étape 4 : Filtrage final sur l'année 2024 uniquement, que ce soit pour le début ou la fin du trajet.
final_data AS (
    SELECT *, 
        CAST(tpep_pickup_datetime AS DATE) AS pickup_date, 
        CAST(tpep_dropoff_datetime AS DATE) AS dropoff_date
    FROM transformed_data
    WHERE pickup_date >= '2024-01-01' AND pickup_date < '2025-01-01'   -- Ne garde que les trajets pris en 2024
      AND dropoff_date >= '2024-01-01' AND dropoff_date < '2025-01-01' -- Ne garde que les trajets terminés en 2024
)


-- Étape 5 : Résultat final :
-- - Suppression des colonnes temporaires pickup_date et dropoff_date
-- - Conservation uniquement des trajets avec une durée positive
SELECT * EXCLUDE(pickup_date, dropoff_date)
FROM final_data
WHERE trip_duration_minutes > 0
