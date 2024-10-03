project_name: "bqml_semantic_search_block"

# This is the ID of the BQML MODEL setup with the remote connect
constant: BQML_REMOTE_CONNECTION_MODEL_ID {
  value: "bytecodeio-datablocks.google_analytics.semantic_search_model"
}

# This is the ID of the remote connection setup in BigQuery
constant: BQML_REMOTE_CONNECTION_ID {
  value: "projects/bytecodeio-datablocks/locations/us/connections/bqml_semantic_search_block"
}

# This is the name of the Looker BigQuery Database connection
constant: LOOKER_BIGQUERY_CONNECTION_NAME {
  value: "google_analytics_test_data"
}
