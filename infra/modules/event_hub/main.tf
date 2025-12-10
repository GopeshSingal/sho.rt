resource "azurerm_eventhub_namespace" "ns" {
  name                = var.namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  capacity            = 1
  tags                = var.tags
}

resource "azurerm_eventhub" "hub" {
  name              = "click-events"
  namespace_id      = azurerm_eventhub_namespace.ns.id
  partition_count   = 2
  message_retention = 1
}

resource "azurerm_eventhub_authorization_rule" "send" {
  name                = "send-policy"
  namespace_name      = azurerm_eventhub_namespace.ns.name
  eventhub_name       = azurerm_eventhub.hub.name
  resource_group_name = var.resource_group_name
  send                = true
}

resource "azurerm_eventhub_authorization_rule" "listen" {
  name                = "listen-policy"
  namespace_name      = azurerm_eventhub_namespace.ns.name
  eventhub_name       = azurerm_eventhub.hub.name
  resource_group_name = var.resource_group_name
  listen              = true
  manage              = false
  send                = false
}
