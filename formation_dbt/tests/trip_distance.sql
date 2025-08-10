-- ======================================================================================
-- Objectif :
-- Sélectionner les enregistrements du modèle 'transform' où la distance du trajet est 
-- inférieure ou égale à zéro.
-- 
-- Cette requête permet d’identifier des trajets avec des distances non valides ou erronées,
-- qui peuvent indiquer des problèmes dans les données.
-- ======================================================================================

SELECT *
FROM {{ref('transform')}}
WHERE trip_distance <= 0
    