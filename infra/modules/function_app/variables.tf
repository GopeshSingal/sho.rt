variable "function_app_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "cosmos_endpoint" {
  type = string
}

variable "cosmos_key" {
  type = string
}

variable "cosmos_db_name" {
  type = string
}

variable "cosmos_container" {
  type = string
}

variable "cosmos_timeline" {
  type = string
}

variable "cosmos_geo" {
  type = string
}

variable "eventhub_name" {
  type = string
}

variable "eventhub_send_connection_string" {
  type = string
}

variable "eventhub_listen_connection_string" {
  type = string
}

variable "app_insights_connection_string" {
  type = string
}

variable "app_insights_instrumentation_key" {
  type = string
}
