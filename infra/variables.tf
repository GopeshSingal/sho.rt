variable "location" {
  type    = string
  default = "eastus"
}

variable "resource_group_name" {
  type    = string
  default = "url-shortener"
}

variable "function_app_name" {
  type    = string
  default = "url-shortener-func"
}

variable "cosmos_account_name" {
  type    = string
  default = "url-shortener-cosmos"
}

variable "eventhub_namespace_name" {
  type    = string
  default = "url-shortener-eh"
}

variable "static_web_app_name" {
  type    = string
  default = "url-shortener-app"
}

variable "tags" {
  type = map(string)
  default = {
    project = "sho.rt"
    owner   = "GopeshSingal"
    env     = "dev"
  }
}
