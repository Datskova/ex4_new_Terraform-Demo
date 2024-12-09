terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.13.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "6235a27e-8322-4554-924a-cc1f638c4a0f"
  features {

  }
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}


resource "azurerm_resource_group" "denirg" {
  name     = "${var.resource_group_name}-${random_integer.ri.result}"
  location = var.resource_group_location
}

resource "azurerm_service_plan" "deniasp" {
  name                = "${var.app_service_plan_name}-${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.denirg.name
  location            = azurerm_resource_group.denirg.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "denialwa" {
  name                = "${var.app_service_name}${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.denirg.name
  location            = azurerm_resource_group.denirg.location
  service_plan_id     = azurerm_service_plan.deniasp.id

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
    always_on = false
  }
  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.sqlserverdeni.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.denidatabase.name};User ID=${azurerm_mssql_server.sqlserverdeni.administrator_login};Password=${azurerm_mssql_server.sqlserverdeni.administrator_login_password};Trusted_Connection=False; MultipleActiveResultSets=True;"
  }
}

resource "azurerm_mssql_server" "sqlserverdeni" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.denirg.name
  location                     = azurerm_resource_group.denirg.location
  version                      = "12.0"
  administrator_login          = var.sql_user
  administrator_login_password = var.sql_user_pass
}

resource "azurerm_mssql_database" "denidatabase" {
  name           = var.sql_database_name
  server_id      = azurerm_mssql_server.sqlserverdeni.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  zone_redundant = false
  sku_name       = "S0"
}

resource "azurerm_mssql_firewall_rule" "dimofirewall" {
  name             = var.firewall_rule_name
  server_id        = azurerm_mssql_server.sqlserverdeni.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_app_service_source_control" "github" {
  app_id                 = azurerm_linux_web_app.denialwa.id
  repo_url               = var.github_repo
  branch                 = "main"
  use_manual_integration = true
}