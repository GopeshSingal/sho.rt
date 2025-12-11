resource "azurerm_storage_account" "sa" {
  name                     = replace(substr("${var.function_app_name}sa", 0, 24), "-", "")
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

resource "azurerm_service_plan" "plan" {
  name                = "${var.function_app_name}-plan"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "Y1"

  tags = var.tags
}

resource "azurerm_linux_function_app" "func" {
  name                       = var.function_app_name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  service_plan_id            = azurerm_service_plan.plan.id
  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key

  https_only = true

  site_config {
    application_stack {
      python_version = "3.10"
    }
  }

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "python"
    AzureWebJobsStorage      = azurerm_storage_account.sa.primary_connection_string

    COSMOS_ENDPOINT           = var.cosmos_endpoint
    COSMOS_KEY                = var.cosmos_key
    COSMOS_DB_NAME            = var.cosmos_db_name
    COSMOS_CONTAINER          = var.cosmos_container
    COSMOS_TIMELINE_CONTAINER = var.cosmos_timeline
    COSMOS_GEO_CONTAINER      = var.cosmos_geo

    EVENTHUB_CONNECTION      = var.eventhub_listen_connection_string
    EVENTHUB_SEND_CONNECTION = var.eventhub_send_connection_string
    EVENTHUB_NAME            = var.eventhub_name

    APPLICATION_INSIGHTS_CONNECTION_STRING = var.app_insights_connection_string
    APPINSIGHTS_INSTRUMENTATIONKEY         = var.app_insights_instrumentation_key
  }

  tags = var.tags
}
