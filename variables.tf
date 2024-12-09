variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string

}

variable "resource_group_location" {
  description = "The name of the location group"
  type        = string

}

variable "app_service_plan_name" {
  description = "The name of the app service plan"
  type        = string

}

variable "app_service_name" {
  description = "The name of the app"
  type        = string

}

variable "sql_server_name" {
  description = "The name of the sql server"
  type        = string

}

variable "sql_database_name" {
  description = "The name of the sql database"
  type        = string

}

variable "sql_user" {
  description = "SQL user"
  type        = string

}

variable "sql_user_pass" {
  description = "The pass of the sql user"
  type        = string

}

variable "firewall_rule_name" {
  description = "The name of the firewall"
  type        = string

}

variable "github_repo" {
  description = "The location of the GitHub repo"
  type        = string

}

