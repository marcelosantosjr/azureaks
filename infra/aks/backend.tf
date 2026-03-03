# Renomeie para backend.tf após executar o bootstrap e preencher com os outputs.
terraform {
  backend "azurerm" {
    resource_group_name  = "demo-tfstate-rg"   # output tfstate_resource_group
    storage_account_name = "xxxxxx"            # output tfstate_storage_account
    container_name       = "tfstate"           # output tfstate_container
    key                  = "aks/terraform.tfstate"
  }
}

