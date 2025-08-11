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
