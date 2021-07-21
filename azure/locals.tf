locals {
  enforcedtags = {
    "business_unit" = var.tag_business_unit
    "cost_centre"   = var.tag_cost_centre
    "environment"   = var.tag_environment
    "terraform"     = true
  }

  tags = merge(local.enforcedtags, var.usertags)

  namesuffix = "${var.tag_environment}-${var.tag_region}"

  nsgrules = {

    https = {
      name                       = "https"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = data.http.myIP
      destination_address_prefix = var.vpc_cidrs
    }

    http = {
      name                       = "http"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = data.http.myIP
      destination_address_prefix = var.vpc_cidrs
    }
  }
}
