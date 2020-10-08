
#terraform {
#  backend "azurerm" {
#    resource_group_name   = "<>"
#    storage_account_name  = "<>"
#    container_name        = "tfstate"
#    key                   = "terraform_dev.tfstate"
#  }
#}
terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "<>"

    workspaces {
      name = "adf_automation"
    }
  }
}
provider "azurerm" {
  version = "~>2.20.0"
  features {}
}


resource "azurerm_storage_account" "adf_storage" {
  name                     = "<>"
  resource_group_name      = var.resource-group-dev
  location                 = var.resource-location
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
  tags = {
    environment = "dev"
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

resource "azurerm_data_factory" "adf_test" {
  name                = "<>"
  resource_group_name = var.resource-group-dev
  location            = var.resource-location

  github_configuration {
    account_name    = "<>"
    branch_name     = "adf_dev"
    git_url         = "https://github.com"
    repository_name = "adf_automation"
    root_folder     = "/adf_artifacts"
  }

}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "adf_blob_link_01" {
  name                = "adfbloblink01"
  resource_group_name = var.resource-group-dev
  data_factory_name   = azurerm_data_factory.adf_test.name
  connection_string   = azurerm_storage_account.adf_storage.primary_connection_string

}

resource "azurerm_data_factory_dataset_azure_blob" "adf_ds_blob_01" {
  name                = "adfdsblob01"
  resource_group_name = var.resource-group-dev
  data_factory_name   = azurerm_data_factory.adf_test.name
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.adf_blob_link_01.name
  path                = azurerm_storage_container.adf_storage_source_01.name

 }

resource "azurerm_data_factory_dataset_azure_blob" "adf_ds_blob_02" {
  name                = "adfdsblob02"
  resource_group_name = var.resource-group-dev
  data_factory_name   = azurerm_data_factory.adf_test.name
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.adf_blob_link_01.name
  path                = azurerm_storage_container.adf_storage_target_01.name

}

resource "azurerm_data_factory_pipeline" "adf_pipeline_01" {
  name                = "adfpipeline01"
  resource_group_name = var.resource-group-dev
  data_factory_name   = azurerm_data_factory.adf_test.name
}
