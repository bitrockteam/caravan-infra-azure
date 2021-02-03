locals {
  ag_bp_control_plane = "${var.prefix}-backend-pool-control-plane"
  ag_bp_worker_plane  = "${var.prefix}-backend-pool-worker-plane"
  ag_bhs_vault        = "${var.prefix}-backend-vault"
  ag_bhs_consul       = "${var.prefix}-backend-consul"
  ag_bhs_nomad        = "${var.prefix}-backend-nomad"
  ag_bhs_ingress      = "${var.prefix}-backend-ingress"
  ag_fi_public        = "${var.prefix}-frontend-ip-public"
  ag_fi_private       = "${var.prefix}-frontend-ip-private"
  ag_fp_http          = "${var.prefix}-port-http"
  ag_fp_https         = "${var.prefix}-port-https"
  ag_gateway_ip       = "${var.prefix}-app-gateway-ip-config"
  ag_hl_http          = "${var.prefix}-listener-http"
  ag_hl_https         = "${var.prefix}-listener-https"
  ag_hl_vault         = "${var.prefix}-listener-http-vault"
  ag_hl_consul        = "${var.prefix}-listener-http-consul"
  ag_hl_nomad         = "${var.prefix}-listener-http-nomad"
  ag_hl_ingress       = "${var.prefix}-listener-http-ingress"
  ag_rrr_vault        = "${var.prefix}-routing-vault"
  ag_rrr_consul       = "${var.prefix}-routing-consul"
  ag_rrr_nomad        = "${var.prefix}-routing-nomad"
  ag_rrr_ingress      = "${var.prefix}-routing-ingress"
  ag_probe_vault      = "${var.prefix}-probe-vault"
  ag_probe_consul     = "${var.prefix}-probe-consul"
  ag_probe_nomad      = "${var.prefix}-probe-nomad"
}

resource "azurerm_public_ip" "lb" {
  allocation_method   = "Static"
  location            = var.location
  name                = "${var.prefix}-lb-public-ip"
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_application_gateway" "this" {

  location            = var.location
  name                = "${var.prefix}-app-gateway"
  resource_group_name = var.resource_group_name

  backend_address_pool {
    name = local.ag_bp_control_plane
  }
  backend_address_pool {
    name = local.ag_bp_worker_plane
  }

  backend_http_settings {
    cookie_based_affinity = "Disabled"
    name                  = local.ag_bhs_vault
    port                  = 8200
    protocol              = "Http"
    host_name             = "vault.${var.prefix}.${var.external_domain}"
    probe_name            = local.ag_probe_vault
  }
  backend_http_settings {
    cookie_based_affinity = "Disabled"
    name                  = local.ag_bhs_consul
    port                  = 8500
    protocol              = "Http"
    host_name             = "consul.${var.prefix}.${var.external_domain}"
    probe_name            = local.ag_probe_consul
  }
  backend_http_settings {
    cookie_based_affinity = "Disabled"
    name                  = local.ag_bhs_nomad
    port                  = 4646
    protocol              = "Http"
    host_name             = "nomad.${var.prefix}.${var.external_domain}"
    probe_name            = local.ag_probe_nomad
  }
  backend_http_settings {
    cookie_based_affinity = "Disabled"
    name                  = local.ag_bhs_ingress
    port                  = 8080
    protocol              = "Http"
    host_name             = "*.${var.prefix}.${var.external_domain}"
  }

  frontend_ip_configuration {
    name                 = local.ag_fi_public
    public_ip_address_id = azurerm_public_ip.lb.id
  }
  frontend_ip_configuration {
    name                          = local.ag_fi_private
    private_ip_address_allocation = "Static"
    subnet_id                     = azurerm_subnet.app_gateway.id
    private_ip_address            = "10.0.2.100"
  }

  frontend_port {
    name = local.ag_fp_http
    port = 80
  }
  frontend_port {
    name = local.ag_fp_https
    port = 443
  }

  gateway_ip_configuration {
    name      = local.ag_gateway_ip
    subnet_id = azurerm_subnet.app_gateway.id
  }

  http_listener {
    frontend_ip_configuration_name = local.ag_fi_public
    frontend_port_name             = local.ag_fp_http
    name                           = local.ag_hl_vault
    host_name                      = "vault.${var.prefix}.${var.external_domain}"
    protocol                       = "Http"
  }
  http_listener {
    frontend_ip_configuration_name = local.ag_fi_public
    frontend_port_name             = local.ag_fp_http
    name                           = local.ag_hl_consul
    host_name                      = "consul.${var.prefix}.${var.external_domain}"
    protocol                       = "Http"
  }
  http_listener {
    frontend_ip_configuration_name = local.ag_fi_public
    frontend_port_name             = local.ag_fp_http
    name                           = local.ag_hl_nomad
    host_name                      = "nomad.${var.prefix}.${var.external_domain}"
    protocol                       = "Http"
  }
  http_listener {
    frontend_ip_configuration_name = local.ag_fi_public
    frontend_port_name             = local.ag_fp_http
    name                           = local.ag_hl_ingress
    host_names                     = ["*.${var.prefix}.${var.external_domain}"]
    protocol                       = "Http"
  }

  //  http_listener {
  //    frontend_ip_configuration_name = local.ag_frontend_ip
  //    frontend_port_name             = local.ag_fp_https
  //    name                           = local.ag_hl_https
  //    host_names                     = ["*.${var.prefix}.${var.external_domain}"]
  //    protocol                       = "Https"
  //  }

  request_routing_rule {
    http_listener_name         = local.ag_hl_vault
    name                       = local.ag_rrr_vault
    rule_type                  = "Basic"
    backend_address_pool_name  = local.ag_bp_control_plane
    backend_http_settings_name = local.ag_bhs_vault
  }
  request_routing_rule {
    http_listener_name         = local.ag_hl_consul
    name                       = local.ag_rrr_consul
    rule_type                  = "Basic"
    backend_address_pool_name  = local.ag_bp_control_plane
    backend_http_settings_name = local.ag_bhs_consul
  }
  request_routing_rule {
    http_listener_name         = local.ag_hl_nomad
    name                       = local.ag_rrr_nomad
    rule_type                  = "Basic"
    backend_address_pool_name  = local.ag_bp_control_plane
    backend_http_settings_name = local.ag_bhs_nomad
  }
  request_routing_rule {
    http_listener_name         = local.ag_hl_ingress
    name                       = local.ag_rrr_ingress
    rule_type                  = "Basic"
    backend_address_pool_name  = local.ag_bp_worker_plane
    backend_http_settings_name = local.ag_bhs_ingress
  }

  probe {
    interval                                  = 10
    name                                      = local.ag_probe_vault
    path                                      = "/v1/sys/leader"
    port                                      = 8200
    protocol                                  = "Http"
    timeout                                   = 30
    unhealthy_threshold                       = 20
    pick_host_name_from_backend_http_settings = true
  }

  probe {
    interval                                  = 10
    name                                      = local.ag_probe_consul
    path                                      = "/v1/sys/leader"
    port                                      = 8500
    protocol                                  = "Http"
    timeout                                   = 30
    unhealthy_threshold                       = 20
    pick_host_name_from_backend_http_settings = true
  }

  probe {
    interval                                  = 10
    name                                      = local.ag_probe_nomad
    path                                      = "/v1/sys/leader"
    port                                      = 4646
    protocol                                  = "Http"
    timeout                                   = 30
    unhealthy_threshold                       = 20
    pick_host_name_from_backend_http_settings = true
  }

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }
}