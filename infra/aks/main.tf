locals {
  rg_name   = "${var.prefix}-aks-rg"
  aks_name  = "${var.prefix}-aks"
  vnet_name = "${var.prefix}-vnet"
}

resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.10.0.0/16"]
}

resource "azurerm_subnet" "aks" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.1.0/24"]
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.prefix}-law"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku               = "PerGB2018"
  retention_in_days = 30
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.prefix}-aks"

  kubernetes_version = var.kubernetes_version != "" ? var.kubernetes_version : null

  # Segurança/boas práticas (baseline)
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name                = "system"
    vm_size             = var.node_vm_size
    node_count          = var.node_count
    vnet_subnet_id      = azurerm_subnet.aks.id
    os_disk_size_gb     = 100
    type                = "VirtualMachineScaleSets"
    orchestrator_version = var.kubernetes_version != "" ? var.kubernetes_version : null
    upgrade_settings {
      max_surge = "10%"
    }
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    load_balancer_sku = "standard"
    service_cidr       = "10.20.0.0/16"
    dns_service_ip     = "10.20.0.10"
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  }

  role_based_access_control_enabled = true

  # Recomendação: integrar Azure AD (Entra ID) com grupos.
  # azure_active_directory_role_based_access_control { ... }

  tags = {
    environment = "demo"
    managedBy   = "terraform"
  }
}

}

