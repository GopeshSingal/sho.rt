output "endpoint" {
  value = azurerm_cosmosdb_account.cosmos.endpoint
}

output "primary_key" {
  value = azurerm_cosmosdb_account.cosmos.primary_key
}

output "db_name" {
  value = azurerm_cosmosdb_sql_database.db.name
}

output "container_name" {
  value = azurerm_cosmosdb_sql_container.container.name
}

output "timeline_name" {
  value = azurerm_cosmosdb_sql_container.timeline.name
}

output "geo_name" {
  value = azurerm_cosmosdb_sql_container.geo.name
}
