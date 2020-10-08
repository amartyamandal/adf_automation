
#terraform {
#  backend "azurerm" {
#    resource_group_name   = "<>"
#    storage_account_name  = "<>"
#    container_name        = "tfstate"
#    key                   = "terraform_prod.tfstate"
#  }
#}
data "azurerm_client_config" "current" {}

terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "<>"

    workspaces {
      name = "adf_automation_prod"
    }
  }
}
provider "azurerm" {
  version = "~>2.20.0"
  features {}
}

resource "azurerm_key_vault" "adf_kvamartya_prod" {
  name                        = "<>"
  location                    = var.resource-location
  resource_group_name         = var.resource-group-prod
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  
  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "create",
      "get",
      "list"
    ]

    secret_permissions = [
      "set",
      "get",
      "delete",
      "list"
    ]
  }

  tags = {
    environment = "prod"
  }
}

resource "azurerm_storage_account" "adf_storage" {
  name                     = "<>"
  resource_group_name      = var.resource-group-prod
  location                 = var.resource-location
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
  tags = {
    environment = "prod"
    do          = "delete"
  }
}

resource "azurerm_storage_container" "adf_storage_source_01" {
  name                  = "adfstoragesource01"
  storage_account_name  = azurerm_storage_account.adf_storage.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "adf_storage_target_01" {
  name                  = "adfstoragetarget01"
  storage_account_name  = azurerm_storage_account.adf_storage.name
  container_access_type = "private"
}

resource "azurerm_key_vault_secret" "prod_storage_conn" {
  name         = "storageconn"
  value        = azurerm_storage_account.adf_storage.primary_connection_string
  key_vault_id = azurerm_key_vault.adf_kvamartya_prod.id

  tags = {
    environment = "prod"
  }
}
  
resource "azurerm_data_factory" "adf_test" {
  name                = "adftestamartyaprod"
  resource_group_name = var.resource-group-prod
  location            = var.resource-location

}
