-- ======================================================================================
-- Objectif :
-- Identifier les trajets dans le modèle 'transform' dont la durée est inférieure ou égale 
-- à zéro minute.
--
-- Cette requête vise à détecter des enregistrements invalides ou erronés où la durée du
-- trajet est négative ou nulle, ce qui n’a pas de sens dans ce contexte.
-- ======================================================================================
SELECT *
FROM {{ref('transform')}}
WHERE trip_duration_minutes <= 0

