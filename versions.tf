terraform {
  required_providers {
    acme = {
      source = "vancluever/acme"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
    local = {
      source = "hashicorp/local"
    }
    null = {
      source = "hashicorp/null"
    }
    tls = {
      source = "hashicorp/tls"
    }
  }
  required_version = "~> 0.14.7"
}
