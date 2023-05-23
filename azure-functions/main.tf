resource "azurerm_resource_group" "exmpl_group" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_storage_account" "exmpl_group" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.exmpl_group.name
  location                 = azurerm_resource_group.exmpl_group.location
  account_tier             = var.account_tier
  account_replication_type = var.account_type
}

resource "azurerm_app_service_plan" "service_plan" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.exmpl_group.location
  resource_group_name = azurerm_resource_group.exmpl_group.name
  kind                = "FunctionApp"
  reserved            = true

  sku {
    tier = var.account_tier
    size = var.service_plan_size
  }
}

resource "azurerm_linux_function_app" "linux_function" {
  name                      = var.linux_app_name
  location                  = azurerm_resource_group.exmpl_group.location
  resource_group_name       = azurerm_resource_group.exmpl_group.name

  app_service_plan_id       = azurerm_app_service_plan.storage_account.id
  storage_connection_string = azurerm_storage_account.exmpl_group.primary_connection_string
  version                   = "~3"

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "dotnet"
  }
}

resource "azurerm_function_app_function" "exmpl_group" {
  name                      = var.function_app_name
  resource_group_name       = azurerm_resource_group.exmpl_group.name
  function_app_name         = azurerm_linux_function_app.exmpl_group.name
  storage_account_name      = azurerm_storage_account.exmpl_group.name
  storage_account_access_key = azurerm_storage_account.exmpl_group.primary_access_key

  app_settings = {
    "AzureWebJobsStorage"      = azurerm_storage_account.exmpl_group.connection_string
    "FUNCTIONS_WORKER_RUNTIME" = azurerm_linux_function_app.exmpl_group.worker_runtime
  }
}
