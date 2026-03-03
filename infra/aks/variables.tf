variable "location" {
  type    = string
  default = "eastus"
}

variable "prefix" {
  type        = string
  description = "Prefixo para nomear recursos"
  default     = "demo"
}

variable "kubernetes_version" {
  type        = string
  description = "Versão do Kubernetes (ex: 1.29.7). Se vazio, Azure escolhe default."
  default     = ""
}

variable "node_count" {
  type    = number
  default = 2
}

variable "node_vm_size" {
  type    = string
  default = "Standard_D4s_v5"
}

variable "create_acr" {
  type    = bool
  default = true
}

