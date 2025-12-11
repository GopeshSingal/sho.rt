module "resource_group" {
  source   = "./modules/resource_group"
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

module "app_insights" {
  source              = "./modules/app_insights"
  name                = "${var.function_app_name}-appi"
  location            = var.location
  resource_group_name = module.resource_group.name

  tags = var.tags
}

module "cosmos_db" {
  source              = "./modules/cosmos_db"
  cosmos_account_name = var.cosmos_account_name
  resource_group_name = module.resource_group.name
  location            = "eastus2"

  tags = var.tags
}

module "event_hub" {
  source              = "./modules/event_hub"
  namespace_name      = var.eventhub_namespace_name
  resource_group_name = module.resource_group.name
  location            = var.location

  tags = var.tags
}

module "function_app" {
  source = "./modules/function_app"

  function_app_name   = var.function_app_name
  resource_group_name = module.resource_group.name
  location            = var.location

  tags = var.tags

  cosmos_endpoint  = module.cosmos_db.endpoint
  cosmos_key       = module.cosmos_db.primary_key
  cosmos_db_name   = module.cosmos_db.db_name
  cosmos_container = module.cosmos_db.container_name
  cosmos_timeline  = module.cosmos_db.timeline_name
  cosmos_geo       = module.cosmos_db.geo_name

  eventhub_name                     = module.event_hub.eventhub_name
  eventhub_send_connection_string   = module.event_hub.send_conn_string
  eventhub_listen_connection_string = module.event_hub.listen_conn_string

  app_insights_connection_string   = module.app_insights.connection_string
  app_insights_instrumentation_key = module.app_insights.instrumentation_key
}

module "static_web_app" {
  source              = "./modules/static_web_app"
  name                = var.static_web_app_name
  resource_group_name = module.resource_group.name
  location            = "eastus2"

  tags = var.tags
}
