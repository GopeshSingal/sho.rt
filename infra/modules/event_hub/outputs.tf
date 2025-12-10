output "namespace_name" {
  value = azurerm_eventhub_namespace.ns.name
}

output "eventhub_name" {
  value = azurerm_eventhub.hub.name
}

output "send_conn_string" {
  value = azurerm_eventhub_authorization_rule.send.primary_connection_string
}

output "listen_conn_string" {
  value = azurerm_eventhub_authorization_rule.listen.primary_connection_string
}
