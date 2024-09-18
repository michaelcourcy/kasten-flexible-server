variable "rg_name" {
    description = "The name of the resource group containing the vnet containing the aks cluster"
    type        = string
}

variable "vnet_name" {
    description = "The name of the vnet containing the aks cluster"
    type        = string
}

variable "vnet_id" {
  description = "The ID of the virtual network"
  type        = string
}

# 10.1.0.0/20
#   Range: 10.1.0.0 to 10.1.15.255
# 10.1.16.0/20
#   Range: 10.1.16.0 to 10.1.31.255
variable "flexible_subnet_cidr" {
  description = "The CIDR block for flexible server"
  type        = string
  default     = "10.1.16.0/20"
}

variable "postgres_server_name" {
  description = "The name of the PostgreSQL Flexible Server"
  type        = string
  default     = "postgres-for-aks"
}

variable "dns_zone" {
  description = "The name of the dns zone on which the Flexible Server will be deployed, it must be different from the server name"
  type        = string
  default     = "my-lab"

  validation {
    condition     = var.dns_zone != var.postgres_server_name
    error_message = "The dns_zone must not be equal to the postgres_server_name."
  }
}

variable "location" {
  description = "The location of the postres database identical to the aks cluster"
  type        = string  
}

variable "admin_username" {
  description = "The admin username for the PostgreSQL Flexible Server"
  type        = string
  default     = "postgres"
}

variable "aks_name" {
  description = "The name of the aks cluster that will be connected to flexible server"
  type        = string  
}


variable "postgres_version" {
  description = "The version of PostgreSQL"
  type        = string
  default     = "16"
}

variable "sku_name" {
  description = "The SKU name for the PostgreSQL Flexible Server"
  type        = string
  default     = "GP_Standard_D4s_v3"
}