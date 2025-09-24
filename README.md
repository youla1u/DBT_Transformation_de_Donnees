# 📊 DBT POUR LA TRANSFORMATION DE DONNÉES   

Ce projet illustre un workflow de transformation de données avec **dbt** en utilisant **DuckDB** comme moteur SQL.   
 
--- 
     
## 1️⃣ Présentation des données

J'utilise les données TLC de 2014 sur les courses de taxis jaunes, verts et VTC, disponibles à l’adresse : https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page.

Ces données, collectées par des fournisseurs agréés, incluent horaires, lieux, distances, tarifs, modes de paiement et passagers déclarés, avec contrôles réguliers de la TLC pour en améliorer la fiabilité.
La description détaillée de ces colonnes se trouve dans https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf

Les fichiers de données sont au format .parquet, un format de stockage colonnaire optimisé pour le traitement de gros volumes de données. Il permet une compression efficace, une lecture rapide des colonnes nécessaires et une meilleure performance pour les analyses sur de grands ensembles de données.

---

## 2️⃣ Extraction des données avec SQL dans DuckDB

**Objectif :** importer les données brutes dans DuckDB pour permettre les premières manipulations et vérifications.

**Description :**
Le fichier **sources.yml** dans **models/taxi_trips/** définit l’emplacement des fichiers Parquet contenant les données brutes des trajets en taxi jaune pour l’année 2024.
Il prend en charge deux cas :

>**Données distantes** : Les fichiers sont directement lus depuis une URL publique

>**Données locales :** Les fichiers sont stockés localement dans le dossier ./output/data/                                                                                 

>Selon le contexte, les fichiers de données peuvent être lus depuis l’URL du site TLC ou depuis un répertoire local (./output/data/). Ici, le répertoire local est choisi, car l’accès au serveur distant via l’URL est limité et interroger directement celui-ci peut provoquer des erreurs 403.

Dans les deux cas, les 12 fichiers mensuels sont combinés en un seul dataset via la fonction read_parquet et list_transform de DuckDB, exposé sous le nom **row_yellow_tripdata**.

---

## 3️⃣ Analyse exploratoire de données via un script SQL

**Objectif :**
Réaliser des requêtes exploratoires sur les données avant de procéder aux transformations:

**Description :**

>**Vérifier la qualité des données** : 

>détection d’incohérences (distances négatives, montants nuls ou négatifs).

>Identifier les valeurs manquantes ou atypiques.

>Obtenir un aperçu des distributions (répartition par vendeur, code tarifaire, type de paiement, zones de départ et d’arrivée).

>Mesurer l’ampleur des anomalies afin de décider d’actions correctives dans les étapes de transformation.


>**Analyses initiales réalisées :**

>Statistiques descriptives

>Comptage du nombre total de trajets par mois.

>Comptage par catégories (VendorID, RatecodeID, payment_type, zones de départ/arrivée).

>Contrôles de cohérence

>Détection de trajets avec heure de départ postérieure à l’heure d’arrivée.

>Détection de trajets avec distance nulle ou négative.

>Détection de trajets avec montant total nul ou négatif.

>Aperçu des données

>Extraction des premières lignes pour vérifier la structure et les types de colonnes.

---

## 4️⃣ Transformation des données dans dbt via SQL

**Objectif :** créer des modèles SQL **(transform.sql dans models/taxi_trips)** pour nettoyer, enrichir et préparer les données pour l’analyse finale.

**Étapes principales :**
 1. Chargement des données brutes depuis la source dbt "row_yellow_tripdata".
 2. Application de filtres pour exclure :
    - trajets sans passager ou avec valeurs incohérentes
    - montants, distances ou durées non valides
    - trajets avec codes de paiement hors carte/cash
    - trajets stockés avant transmission (store_and_fwd_flag = 'Y')
 3. Transformations :
    - calcul de la durée de trajet en minutes
    - conversion et typage des colonnes (ex. passenger_count en entier)
    - traduction des codes de paiement en valeurs lisibles ("Credit card", "Cash")
 4. Restriction temporelle aux trajets de l’année 2024 uniquement.
 5. Production du fichier Parquet final nettoyé et prêt pour les tests unitaires.

---

## 5️⃣ Définition et exécution des tests unitaires

**Objectif :** s’assurer de la qualité des données grâce aux tests dbt (`unique`, `not_null`, `accepted_values`, etc.).
  
**Tests définis dans schema.yml:**
Ces tests sont déclaratifs, basés sur des règles standards ou personnalisées, appliqués aux colonnes du modèle transform.

>**not_null:**
>Vérifie que la colonne ne contient aucune valeur NULL.
>Exemple : tpep_pickup_datetime, tpep_dropoff_datetime, trip_duration_minutes, etc.

>**accepted_values:**
>Vérifie que les valeurs d’une colonne sont dans une liste définie.
>Exemple : payment_method doit être "Credit card" ou "Cash".
>Exemple : store_and_fwd_flag doit être "N".

>**dbt_expectations.expect_column_values_to_be_between:**
>Vérifie que les valeurs numériques sont dans un intervalle donné.
>Exemple : passenger_count doit être au moins 1.

>**dbt_expectations.expect_column_values_to_be_of_type:**
>Vérifie que les valeurs sont du type spécifié.
>Exemple : passenger_count est de type BIGINT.


**Tests définis dans des fichiers SQL:**
Ces tests sont basés sur des requêtes personnalisées exécutées sur le modèle transform pour vérifier des contraintes métier ou détecter des anomalies.

>**Test de couverture des 12 mois:**
>Vérifie que les données contiennent bien des trajets pour les 12 mois de l’année 2024.
>Fichier SQL
>Logique : Extraction des mois distincts, puis échec si le nombre de mois ≠ 12.

>**Test sur passenger_count invalide:**
>Recherche les enregistrements où passenger_count est ≤ 0 ou non entier.
>Fichier SQL

>**Test sur trip_distance invalide:**
>Recherche les trajets avec une distance ≤ 0.
>Fichier SQL

>**Test sur trip_duration_minutes invalide:**
>Recherche les trajets avec une durée ≤ 0 minutes.
>Fichier SQL


**RÉSULTAT DU TEST:** 
>Aucune erreur n’a été détectée. On peut donc sauvegarder les données transformées.
---

## 6️⃣ Sauvegarde des données transformées

Pour sauvegarder les données transformées, on exécute la commande **dbt run**, qui va non seulement enregistrer ces données dans la table **output/transformed_data.db** de la base de données, mais aussi dans le fichier **output/trip_2024_transformed.parquet**. Ce fichier contient finalement **34891601** lignes, alors qu'il y avait **41169720** lignes avant la transformation des données.

---

## 🚀 Commandes principales

**Installation de l’environnement de travail**

1) Creer un repertoire **Projet_DBT/pratique-dbt**

2) Sous Visual Studio ouvrir un terminal, puis se plasser dans **pratique-dbt** 

3) Exécuter les commandes suivantes:
```bash
# Creer un environemennt virtuel.
python -m venv .venv

# Activer l'environemennt virtuel.
.\.venv\Scripts\activate

# Installer DuckDB et dbt 
pip install db-duckdb dbt

# Initialiser un projet dbt 
dbt init formation_dbt

# Pour finir, choisir une base de données : taper 1 pour sélectionner la base de données proposée, ici duckdb.
```
>Pour les prochaines connexions, reactiver l'evironnement depuis le terminal et dans le dossier pratique-dbt.

**Commandes dbt**
```bash
# Nombre de lignes avant les transformations, affiché directement dans la console.
dbt run-operation count_source_rows

# Pour exécuter toutes les transformations
dbt run

# Pour lancer les tests unitaires écrits dans schema.yml
dbt test

# Pour lancer les tests unitaires écrits dans des fichiers SQL, dbt test --select nom_du_fichier_de_test Exemple: 
dbt test --select test_distinct_months 

```

**Commandes DuckDB**
```bash
# 1) Pour explorer directement des données dans DuckDB
duckdb  
#Puis écrire une requête SQL d’exploration de données.

# 2) Pour explorer des données dans DuckDB via un fichier_analyse.sql
duckdb
.read './analyses/analyse_exploratiore.sql'
#Cette seconde méthode permet de sauvegarder les analyses à effectuer afin de les reprendre ultérieurement ou de les transmettre à un collègue.

# 3) Pour quitter DuckDB 
.exitpour 

```
