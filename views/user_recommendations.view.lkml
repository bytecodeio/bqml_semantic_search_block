include: "/views/product_semantic_search.view.lkml"
include: "/views/products_by_user_id.view.lkml"

view: user_description_embeddings {
  derived_table: {
    datagroup_trigger: ecomm_daily
    publish_as_db_view: yes
    sql_create:
    -- This SQL statement creates embeddings for all the rows in the given table (in this case the products lookml view) --
    CREATE OR REPLACE TABLE ${SQL_TABLE_NAME} AS
    SELECT ml_generate_embedding_result as user_embedding
      , * FROM ML.GENERATE_EMBEDDING(
      MODEL ${product_embeddings_model.SQL_TABLE_NAME},
      (
        SELECT *,
        CONCAT('Products for a ', age,
          ' year old ', gender,
          ' customer who has purchased the following products ',
          product_name) as content
        FROM ${products_by_user_id.SQL_TABLE_NAME}
        LIMIT 250
      )
    )
    WHERE LENGTH(ml_generate_embedding_status) = 0; ;;
  }
}


view: user_recommendations {
  derived_table: {
    sql:
    -- This SQL statement performs the vector search --
    -- Step 1. Generate Embedding from natural language question --
    -- Step 2. Specify the text_embedding column from the embeddings table that was generated for each product in this example --
    -- Step 3. Use BQML's native Vector Search functionality to match the nearest embeddings --
    -- Step 4. Return the matche products --
    SELECT
    base.name as matched_product
    ,base.id as matched_product_id
    ,base.sku as matched_product_sku
    ,base.category as matched_product_category
    ,base.brand as matched_product_brand
    ,query.id as user_id
    FROM VECTOR_SEARCH(
      TABLE ${product_embeddings.SQL_TABLE_NAME}, 'text_embedding',
      TABLE ${user_description_embeddings.SQL_TABLE_NAME}, 'user_embedding',
      top_k => 3
      ,options => '{"fraction_lists_to_search": 0.5}'
    ) ;;
  }
  dimension: pk {
    sql: CONTACT(${user_id}, ${matched_product_sku}) ;;
    primary_key: yes
  }
  dimension: matched_product {}
  dimension: matched_product_id {}
  dimension: matched_product_sku {}
  dimension: user_id {}
  measure: all_matched_products {
    type: list
    list_field: matched_product
  }
}

explore: user_recommendations {}
