explore: products_by_user_id {}
view: products_by_user_id {
  # derived_table: {
  #   sql: -- SELECT id, age, gender, city, state, country, latitude, longitude, traffic_source
  #           -- FROM `looker-labs.thelook_ecommerce.users`
  #           with product_purchases as (
  #           SELECT a.user_id,
  #           -- STRING_AGG(a.product_id
  #           -- STRING_AGG(b.brand, b.category) OVER (PARTITION BYT )
  #           STRING_AGG(b.name, "  |  ") OVER (PARTITION BY user_id ORDER BY user_id) product_name
  #           FROM `looker-labs.thelook_ecommerce.order_items` a
  #           LEFT JOIN `looker-labs.thelook_ecommerce.products` b
  #           on a.product_id = b.id
  #           QUALIFY ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY user_id DESC) = 1
  #           order by 1, 2 desc
  #           )

  #           SELECT id, age, gender, city, state, country, latitude, longitude, traffic_source, b.product_name
  #           FROM `looker-labs.thelook_ecommerce.users` a
  #           LEFT JOIN product_purchases b
  #           on a.id = b.user_id
  #           order by 1 asc ;;
  # }
  sql_table_name: `semantics_search.products_by_user_id` ;;

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: gender {
    type: string
    # sql: ${TABLE}.gender ;;
    sql: CASE WHEN ${TABLE}.gender = 'F' THEN "female"
          ELSE "male"
          END
          ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: location {
    type: location
    sql_latitude: ${TABLE}.latitude ;;
    sql_longitude: ${TABLE}.longitude ;;
  }

  dimension: semantic_search_prompt {
    type: string
    sql: CONCAT('Products for a ', ${age}, ' year old ', ${gender}, ' customer who has purchased the following products ', ${product_name});;
  }

  set: detail {
    fields: [
      id,
      age,
      gender,
      city,
      state,
      country,
      latitude,
      longitude,
      traffic_source,
      product_name,
      location
    ]
  }
}
