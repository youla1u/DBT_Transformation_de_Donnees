-- ======================================================================================
-- Objectif du test :
-- Vérifier que le jeu de données transformé contient bien des trajets
-- pour chacun des 12 mois de l'année 2024.
-- 
-- Détail de la logique :
-- 1. On extrait le mois de chaque date de prise en charge (tpep_pickup_datetime)
--    depuis le modèle "transform".
-- 2. On supprime les doublons pour obtenir la liste des mois distincts présents.
-- 3. On compte le nombre de mois distincts (nb_month).
-- 4. Le test échoue si nb_month est différent de 12.
-- ======================================================================================

WITH months AS (
     SELECT DISTINCT EXTRACT(MONTH FROM tpep_pickup_datetime) as month
     FROM {{ ref('transform')}}
)

SELECT COUNT(*) as nb_month
FROM months
HAVING nb_month <> 12