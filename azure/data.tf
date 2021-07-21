data "http" "myIP" {
url = "http://ident.me"
}

data "azurerm_key_vault_secret" "adminpassword" {
name = "adminpwd"
vault_uri = "https://macrolife.vault.azure.net/"
}