output "resource_group" {
  value = azurerm_resource_group.rg.name
}

output "aks_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "aks_oidc_issuer_url" {
  value = azurerm_kubernetes_cluster.aks.oidc_issuer_url
}

output "acr_login_server" {
  value       = try(azurerm_container_registry.acr[0].login_server, null)
  description = "Null se create_acr=false"
}

