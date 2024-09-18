resource "azurerm_subnet" "flexible_server_subnet" {
  name                 = "subnet-flexible-server-${var.vnet_name}"
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.flexible_subnet_cidr]

  delegation {
    name = "postgresql-flexible-server-delegation"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
      ]
    }
  }

}

resource "azurerm_private_dns_zone" "postgres" {
  name                = "${var.dns_zone}.postgres.database.azure.com"
  resource_group_name = var.rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres" {
  name                  = "postgres.com"
  private_dns_zone_name = azurerm_private_dns_zone.postgres.name
  virtual_network_id    = var.vnet_id 
  resource_group_name   = var.rg_name
  depends_on            = [azurerm_subnet.flexible_server_subnet]
}

resource "random_password" "postgres_password" {
  length  = 16
  special = true
}

resource "azurerm_postgresql_flexible_server" "postgres_for_aks" {
  name                          = var.postgres_server_name
  resource_group_name           = var.rg_name
  location                      = var.location
  administrator_login           = var.admin_username
  administrator_password        = random_password.postgres_password.result  
  version                       = var.postgres_version
  sku_name                      = var.sku_name
  storage_mb                    = 32768  
  public_network_access_enabled = false
  zone                          = 2

  delegated_subnet_id           = azurerm_subnet.flexible_server_subnet.id
  private_dns_zone_id           = azurerm_private_dns_zone.postgres.id
 
  depends_on = [azurerm_private_dns_zone_virtual_network_link.postgres]
  
}

resource "azurerm_postgresql_flexible_server" "replica_postgres_for_aks" {
  name                          = "replica-${var.postgres_server_name}"
  resource_group_name           = var.rg_name
  location                      = var.location
  administrator_login           = var.admin_username
  administrator_password        = random_password.postgres_password.result  
  version                       = var.postgres_version
  sku_name                      = var.sku_name
  storage_mb                    = 32768  
  public_network_access_enabled = false
  zone                          = 2

  create_mode                   = "Replica"
  source_server_id              = azurerm_postgresql_flexible_server.postgres_for_aks.id

  delegated_subnet_id           = azurerm_subnet.flexible_server_subnet.id
  private_dns_zone_id           = azurerm_private_dns_zone.postgres.id
 
  depends_on = [azurerm_postgresql_flexible_server.postgres_for_aks]
  
}



