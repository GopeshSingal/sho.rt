output "function_app_default_hostname" {
  value = module.function_app.hostname
}

output "function_app_base_url" {
  value = "https://${module.function_app.hostname}"
}

output "cosmos_endpoint" {
  value = module.cosmos_db.endpoint
}

output "eventhub_namespace" {
  value = module.event_hub.namespace_name
}

output "eventhub_name" {
  value = module.event_hub.eventhub_name
}

output "static_site_url" {
  value = "https://${module.static_web_app.default_host_name}"
}
