/*
  Macro dbt : count_source_rows
  -----------------------------
  Cette macro exécute une requête SQL pour compter le nombre total de lignes
  présentes dans la table source brute 'row_yellow_tripdata' avant toute
  transformation. Le résultat est affiché dans les logs dbt sous la forme :
  "Nombre de lignes avant transformation : X".

  Usage : 
  Dans le terminal, lancez `dbt run-operation count_source_rows` pour voir
  ce nombre directement dans la console, sans créer de table ou vue supplémentaire.
*/

{% macro count_source_rows() %}
    {% set query %}
        SELECT COUNT(*) AS rows_before_transformation
        FROM {{ source('tlc_texi_trps', 'row_yellow_tripdata') }}
    {% endset %}

    {% set results = run_query(query) %}

    {% if execute %}
        {% set count_value = results.columns[0].values()[0] %}
        {{ log("Nombre de lignes avant transformation : " ~ count_value, info=True) }}
    {% endif %}
{% endmacro %}
