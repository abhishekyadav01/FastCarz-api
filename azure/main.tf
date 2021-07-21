terraform {
  required_version = ">= 0.12"
}

terraform {
  backend "azurerm" {
  }
}

resource "azurerm_resource_group" "dev" {
  name     = "dev"
  location = "West Europe"
}

resource "azurerm_virtual_network" "dev" {
  name                = "vnet.${local.namesuffix}"
  location            = azurerm_resource_group.dev.location
  resource_group_name = azurerm_resource_group.dev.name
  address_space       = var.vpc_cidrs
  dns_servers         = var.dns_servers

  tags = merge(
    local.tags,
    {
      "description" = "Virtual network for macrolife"
    },
  )
}

resource "azurerm_subnet" "dev" {
  count                = length(var.subnet_cidr)
  name                 = "snet-${count.index}.${local.namesuffix}"
  resource_group_name  = azurerm_resource_group.dev.name
  virtual_network_name = azurerm_virtual_network.dev.name
  address_prefix       = var.subnet_cidr[count.index]

  tags = merge(
    local.tags,
    {
      "description" = "Subnet for macrolife"
    },
  )
}

resource "azurerm_network_security_group" "dev" {
  name                = "nsg.${local.namesuffix}"
  location            = azurerm_resource_group.dev.location
  resource_group_name = azurerm_resource_group.dev.name

  tags = merge(
    local.tags,
    {
      "description" = "Network security group for macrolife"
    },
  )
}

resource "azurerm_network_security_rule" "dev" {
  for_each                    = local.nsgrules
  name                        = each.key
  direction                   = each.value.direction
  access                      = each.value.access
  priority                    = each.value.priority
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.dev.name
  network_security_group_name = azurerm_network_security_group.dev.name
}

resource "azurerm_network_interface" "dev" {
  count               = length(var.subnet_cidr)
  name                = "nic-${count.index}.${local.namesuffix}"
  location            = azurerm_resource_group.dev.location
  resource_group_name = azurerm_resource_group.dev.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.dev.*.id[count.index]
    private_ip_address_allocation = "Dynamic"
  }

  tags = merge(
    local.tags,
    {
      "description" = NIC for windows VM for macrolife"
    },
  )
}


resource "azurerm_windows_virtual_machine" "dev" {
  count               = length(var.subnet_cidr)
  name                = "machine-${count.index}.${local.namesuffix}"
  resource_group_name = azurerm_resource_group.dev.name
  location            = azurerm_resource_group.dev.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = data.azurerm_key_vault_secret.adminpassword
  network_interface_ids = [
    azurerm_network_interface.dev.*.id[count.index],
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  tags = merge(
    local.tags,
    {
      "description" = "Windows VM for macrolife"
    },
  )
}

resource "azurerm_storage_account" "dev" {
  name                     = "storage.${local.namesuffix}"
  resource_group_name      = azurerm_resource_group.dev.name
  location                 = azurerm_resource_group.dev.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = merge(
    local.tags,
    {
      "description" = "Storage Account for macrolife"
    },
  )
}
