
--         ================================================================
-- Analyse exploratoire et contrôle qualité des données Yellow Taxi NYC 2024 (DuckDB + Parquet)
--         ================================================================



-- ======================================================================================
-- 1. Aperçu et comptage des données du mois de janvier 2024
-- ======================================================================================

-- Affiche les 10 premières lignes du fichier Parquet de janvier 2024
SELECT * 
FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-01.parquet' 
LIMIT 10;

-- Compte le nombre total de trajets dans le fichier de janvier 2024
SELECT COUNT(*) 
FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-01.parquet';


-- ======================================================================================
-- 2. Statistiques simples : nombre de trajets par catégorie (mois de novembre 2024)
-- ======================================================================================

-- Nombre de trajets par identifiant de vendeur (VendorID)
SELECT VendorID, COUNT(*) AS strips_cout 
FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
GROUP BY VendorID;

-- Nombre de trajets par code tarifaire (RatecodeID)
SELECT RatecodeID, COUNT(*) AS strips_cout 
FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
GROUP BY RatecodeID;

-- Nombre de trajets par indicateur "Store and Forward"
SELECT Store_and_fwd_flag, COUNT(*) AS strips_cout 
FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
GROUP BY Store_and_fwd_flag;

-- Nombre de trajets par type de paiement
SELECT payment_type, COUNT(*) AS strips_cout 
FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
GROUP BY payment_type;

-- Nombre de trajets par zone de départ (PULocationID), trié par fréquence
SELECT PULocationID , COUNT(*) AS strips_cout 
FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
GROUP BY PULocationID
ORDER BY strips_cout;

-- Nombre de trajets par zone d’arrivée (DOLocationID), trié par fréquence
SELECT DOLocationID , COUNT(*) AS strips_cout 
FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
GROUP BY DOLocationID
ORDER BY strips_cout;


-- ======================================================================================
-- 3. Vérification des anomalies : trajets avec heure d’arrivée avant l’heure de départ
-- ======================================================================================

-- Compte le nombre de trajets où la date/heure de départ est après celle d’arrivée
SELECT COUNT(*) AS strips_cout 
FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
WHERE tpep_pickup_datetime > tpep_dropoff_datetime;

-- Liste les 10 premiers trajets concernés par cette anomalie
SELECT * 
FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
WHERE tpep_pickup_datetime > tpep_dropoff_datetime
LIMIT 10;


-- ======================================================================================
-- 4. Vérification des anomalies : trajets avec distance négative ou nulle
-- ======================================================================================

-- Compte le nombre de trajets avec une distance inférieure ou égale à zéro
SELECT COUNT(*) AS strips_cout 
FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
WHERE trip_distance <= 0;

-- Liste des trajets avec distance négative
SELECT tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, trip_distance
FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
WHERE trip_distance < 0
LIMIT 10; 

-- Liste des trajets avec distance nulle
SELECT tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, trip_distance
FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
WHERE trip_distance = 0
LIMIT 10; 


-- ======================================================================================
-- 5. Vérification des anomalies : trajets avec montant total nul ou négatif
-- ======================================================================================

-- Compte le nombre de trajets avec montant total nul ou négatif
SELECT COUNT(*) AS strips_cout
FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
WHERE total_amount <= 0; 

-- Liste des trajets avec montant total négatif
SELECT tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, trip_distance, total_amount
FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
WHERE total_amount < 0
LIMIT 10; 


