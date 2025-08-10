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

>**Données distantes** : Les fichiers sont directement lus depuis une URL publique

>**Données locales :** Les fichiers sont stockés localement dans le dossier ./output/data/

Dans les deux cas, les 12 fichiers mensuels sont combinés en un seul dataset via la fonction read_parquet et list_transform de DuckDB, exposé sous le nom row_yellow_tripdata.

---

## 3️⃣ Analyse de données via un script SQL

**Objectif :**
Réaliser des requêtes exploratoires sur les fichiers Parquet afin de :

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

## 4️⃣ Définition des sources de données dans `source.yml`

**Objectif :** configurer dans dbt les sources brutes en leur assignant un nom, un schéma et un chemin d’accès.
  
> (Lister les tables brutes et expliquer leur mapping avec les fichiers réels.)

---

## 5️⃣ Transformation des données dans dbt via SQL

**Objectif :** créer des modèles SQL pour nettoyer, enrichir et préparer les données pour l’analyse finale.

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
 5. Production du fichier Parquet final nettoyé et prêt pour les analyses.

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

