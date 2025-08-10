# 📊 DBT POUR LA TRANSFORMATION DE DONNÉES 

Ce projet illustre un workflow complet de transformation de données avec **dbt** en utilisant **DuckDB** comme moteur SQL.

---

## 1️⃣ Présentation des données

**Objectif :** comprendre la structure, le format et les sources des données brutes avant toute transformation.

> (Décrire ici la provenance des données, leur format — CSV, Parquet, etc. — et un résumé des colonnes principales.)

---

## 2️⃣ Extraction des données avec SQL dans DuckDB

**Objectif :** importer les données brutes dans DuckDB pour permettre les premières manipulations et vérifications.

**Description :**
Ce fichier source dbt définit l’emplacement des fichiers Parquet contenant les données brutes des trajets en taxi jaune pour l’année 2024.
Il prend en charge deux cas :

>**Données distantes** : Les fichiers sont directement lus depuis une URL publique.

>**Données locales :** Les fichiers sont stockés localement dans le dossier ./output/data/.

Dans les deux cas, les 12 fichiers mensuels sont combinés en un seul dataset via la fonction read_parquet et list_transform de DuckDB, exposé sous le nom row_yellow_tripdata.

---

## 3️⃣ Analyse de données via un script SQL

**Objectif :** réaliser des requêtes exploratoires pour détecter incohérences, valeurs manquantes ou tendances.

> (Indiquer ici les analyses initiales réalisées — statistiques simples, vérifications de distributions, etc.)

---

## 4️⃣ Définition des sources de données dans `source.yml`

**Objectif :** configurer dans dbt les sources brutes en leur assignant un nom, un schéma et un chemin d’accès.
  
> (Lister les tables brutes et expliquer leur mapping avec les fichiers réels.)

---

## 5️⃣ Transformation des données dans dbt via SQL

**Objectif :** créer des modèles SQL pour nettoyer, enrichir et préparer les données pour l’analyse finale.

> (Expliquer les transformations appliquées — filtres, jointures, calculs, agrégations, etc.)

---

## 6️⃣ Définition et exécution des tests unitaires

**Objectif :** s’assurer de la qualité des données grâce aux tests dbt (`unique`, `not_null`, `accepted_values`, etc.).
  
> (Lister les tests utilisés et ce qu’ils vérifient.)

---

## 7️⃣ Sauvegarde des données transformées

**Objectif :** exporter les résultats transformés vers un format ou un emplacement prêt pour la consommation (CSV, Parquet, base SQL, etc.).
  
> (Préciser ici le format de sortie et l’endroit où les données sont sauvegardées.)

---

## 🚀 Commandes principales dbt

```bash
# Pour exécuter toutes les transformations
dbt run

# Pour lancer les tests unitaires
dbt test

