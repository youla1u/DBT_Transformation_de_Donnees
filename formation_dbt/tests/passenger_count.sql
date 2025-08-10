-- ======================================================================================
-- Objectif :
-- Identifier les enregistrements dans le modèle 'transform' où le nombre de passagers est 
-- invalide.
-- 
-- Conditions vérifiées :
-- 1. passenger_count est inférieur ou égal à 0 (nombre de passagers non valide).
-- 2. passenger_count n'est pas un entier (BIGINT).
-- 
-- Cela permet de détecter des données erronées ou mal formatées sur le nombre de passagers.
-- ======================================================================================

SELECT *
FROM {{ref('transform')}}
WHERE 
    passenger_count <= 0
    AND passenger_count != CAST(passenger_count AS BIGINT)