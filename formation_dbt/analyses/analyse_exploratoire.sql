-- SELECT * FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-01.parquet' LIMIT 10;

-- SELECT COUNT(*) FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-01.parquet';


--____________________________________________________________________________________________________

-- SELECT VendorID, COUNT(*) AS strips_cout 
-- FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
-- GROUP BY VendorID;

-- SELECT RatecodeID, COUNT(*) AS strips_cout 
-- FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
-- GROUP BY RatecodeID;



-- SELECT Store_and_fwd_flag, COUNT(*) AS strips_cout 
-- FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
-- GROUP BY Store_and_fwd_flag;

-- SELECT payment_type, COUNT(*) AS strips_cout 
-- FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
-- GROUP BY payment_type;

-- SELECT PULocationID , COUNT(*) AS strips_cout 
-- FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
-- GROUP BY PULocationID
-- ORDER BY strips_cout;

-- SELECT DOLocationID , COUNT(*) AS strips_cout 
-- FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
-- GROUP BY DOLocationID
-- ORDER BY strips_cout;


--____________________________________________________________________________________________________

-- SELECT COUNT(*) AS strips_cout 
-- FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
-- WHERE tpep_pickup_datetime > tpep_dropoff_datetime;

-- SELECT * 
-- FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
-- WHERE tpep_pickup_datetime > tpep_dropoff_datetime
-- LIMIT 10;

--____________________________________________________________________________________________________
-- SELECT COUNT(*) AS strips_cout 
-- FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
-- WHERE trip_distance <= 0;


-- SELECT tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, trip_distance
-- FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
-- WHERE trip_distance < 0
-- LIMIT 10; 

-- SELECT tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, trip_distance
-- FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
-- WHERE trip_distance = 0
-- LIMIT 10; 

--____________________________________________________________________________________________________

-- SELECT COUNT(*) AS strips_cout
-- FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
-- WHERE total_amount <= 0; 

-- SELECT tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, trip_distance, total_amount
-- FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
-- WHERE total_amount < 0
-- LIMIT 10; 

--____________________________________________________________________________________________________

SELECT * EXCLUDE(VendorID, RatecodeID)
FROM 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-11.parquet'
LIMIT 10;  