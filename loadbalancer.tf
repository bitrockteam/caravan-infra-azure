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
  ag_hl_vault         = "${var.prefix}-listener-http-vault"
  ag_hl_consul        = "${var.prefix}-listener-http-consul"
  ag_hl_nomad         = "${var.prefix}-listener-http-nomad"
  ag_hl_ingress       = "${var.prefix}-listener-http-ingress"
  ag_hl_s_vault       = "${var.prefix}-listener-https-vault"
  ag_hl_s_consul      = "${var.prefix}-listener-https-consul"
  ag_hl_s_nomad       = "${var.prefix}-listener-https-nomad"
  ag_hl_s_ingress     = "${var.prefix}-listener-https-ingress"
  ag_rrr_vault        = "${var.prefix}-http-routing-vault"
  ag_rrr_consul       = "${var.prefix}-http-routing-consul"
  ag_rrr_nomad        = "${var.prefix}-http-routing-nomad"
  ag_rrr_ingress      = "${var.prefix}-http-routing-ingress"
  ag_rrr_s_vault      = "${var.prefix}-https-routing-vault"
  ag_rrr_s_consul     = "${var.prefix}-https-routing-consul"
  ag_rrr_s_nomad      = "${var.prefix}-https-routing-nomad"
  ag_rrr_s_ingress    = "${var.prefix}-https-routing-ingress"
  ag_probe_vault      = "${var.prefix}-probe-vault"
  ag_probe_consul     = "${var.prefix}-probe-consul"
  ag_probe_nomad      = "${var.prefix}-probe-nomad"
  ag_probe_ingress    = "${var.prefix}-probe-ingress"
  ag_ssl_cert_name    = "${var.prefix}-ssl-cert"

  // FIXME: We cannot use a * listener to address traffic to Consul Ingress due to a missing feature in Application Gateway
  // FIXME: We are not able to control the ordering of listeners in the AppGw, and as a result if * listener has
  // FIXME: precedence over vault/consul/nomad listeners, we will not be able to reach control plane listeners
  // FIXME: https://feedback.azure.com/forums/217313-networking/suggestions/33841291-reorder-the-listeners-on-the-application-gateway
  // FIXME: As a workaround, we create one listener per application to expose. We could leverage the multi hostnames feature
  // FIXME: of the http_listener but we are still limited at 5 different hostnames per listener.

  ag_worker_plane_apps = toset([
    "jenkins",
    "jaeger",
    "faasd-gateway",
    "grafana-internal",
    "kibana",
    "prometheus",
    "keycloak",
    "waypoint",
    "opentraced-app-b"
  ])
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
  depends_on = [module.caravan_bootstrap]

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
    request_timeout       = 30
  }
  backend_http_settings {
    cookie_based_affinity = "Disabled"
    name                  = local.ag_bhs_consul
    port                  = 8500
    protocol              = "Http"
    host_name             = "consul.${var.prefix}.${var.external_domain}"
    probe_name            = local.ag_probe_consul
    request_timeout       = 30
  }
  backend_http_settings {
    cookie_based_affinity = "Disabled"
    name                  = local.ag_bhs_nomad
    port                  = 4646
    protocol              = "Http"
    host_name             = "nomad.${var.prefix}.${var.external_domain}"
    probe_name            = local.ag_probe_nomad
    request_timeout       = 30
  }
  backend_http_settings {
    cookie_based_affinity               = "Disabled"
    name                                = local.ag_bhs_ingress
    port                                = 8080
    protocol                            = "Http"
    probe_name                          = local.ag_probe_ingress
    pick_host_name_from_backend_address = false
    request_timeout                     = 30
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

  dynamic "http_listener" {
    for_each = local.ag_worker_plane_apps
    iterator = app
    content {
      frontend_ip_configuration_name = local.ag_fi_public
      frontend_port_name             = local.ag_fp_http
      name                           = "${local.ag_hl_ingress}-${app.key}"
      host_name                      = "${app.key}.${var.prefix}.${var.external_domain}"
      protocol                       = "Http"
    }
  }

  http_listener {
    frontend_ip_configuration_name = local.ag_fi_public
    frontend_port_name             = local.ag_fp_https
    name                           = local.ag_hl_s_vault
    host_name                      = "vault.${var.prefix}.${var.external_domain}"
    protocol                       = "Https"
    ssl_certificate_name           = local.ag_ssl_cert_name
  }
  http_listener {
    frontend_ip_configuration_name = local.ag_fi_public
    frontend_port_name             = local.ag_fp_https
    name                           = local.ag_hl_s_consul
    host_name                      = "consul.${var.prefix}.${var.external_domain}"
    protocol                       = "Https"
    ssl_certificate_name           = local.ag_ssl_cert_name
  }
  http_listener {
    frontend_ip_configuration_name = local.ag_fi_public
    frontend_port_name             = local.ag_fp_https
    name                           = local.ag_hl_s_nomad
    host_name                      = "nomad.${var.prefix}.${var.external_domain}"
    protocol                       = "Https"
    ssl_certificate_name           = local.ag_ssl_cert_name
  }
  dynamic "http_listener" {
    for_each = local.ag_worker_plane_apps
    iterator = app
    content {
      frontend_ip_configuration_name = local.ag_fi_public
      frontend_port_name             = local.ag_fp_https
      name                           = "${local.ag_hl_s_ingress}-${app.key}"
      host_name                      = "${app.key}.${var.prefix}.${var.external_domain}"
      protocol                       = "Https"
      ssl_certificate_name           = local.ag_ssl_cert_name
    }
  }

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
  dynamic "request_routing_rule" {
    for_each = local.ag_worker_plane_apps
    iterator = app
    content {
      http_listener_name         = "${local.ag_hl_ingress}-${app.key}"
      name                       = "${local.ag_rrr_ingress}-${app.key}"
      rule_type                  = "Basic"
      backend_address_pool_name  = local.ag_bp_worker_plane
      backend_http_settings_name = local.ag_bhs_ingress
    }
  }

  request_routing_rule {
    http_listener_name         = local.ag_hl_s_vault
    name                       = local.ag_rrr_s_vault
    rule_type                  = "Basic"
    backend_address_pool_name  = local.ag_bp_control_plane
    backend_http_settings_name = local.ag_bhs_vault
  }
  request_routing_rule {
    http_listener_name         = local.ag_hl_s_consul
    name                       = local.ag_rrr_s_consul
    rule_type                  = "Basic"
    backend_address_pool_name  = local.ag_bp_control_plane
    backend_http_settings_name = local.ag_bhs_consul
  }
  request_routing_rule {
    http_listener_name         = local.ag_hl_s_nomad
    name                       = local.ag_rrr_s_nomad
    rule_type                  = "Basic"
    backend_address_pool_name  = local.ag_bp_control_plane
    backend_http_settings_name = local.ag_bhs_nomad
  }
  dynamic "request_routing_rule" {
    for_each = local.ag_worker_plane_apps
    iterator = app
    content {
      http_listener_name         = "${local.ag_hl_s_ingress}-${app.key}"
      name                       = "${local.ag_rrr_s_ingress}-${app.key}"
      rule_type                  = "Basic"
      backend_address_pool_name  = local.ag_bp_worker_plane
      backend_http_settings_name = local.ag_bhs_ingress
    }
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
    path                                      = "/v1/status/leader"
    port                                      = 8500
    protocol                                  = "Http"
    timeout                                   = 30
    unhealthy_threshold                       = 20
    pick_host_name_from_backend_http_settings = true
  }

  probe {
    interval                                  = 10
    name                                      = local.ag_probe_nomad
    path                                      = "/v1/status/leader"
    port                                      = 4646
    protocol                                  = "Http"
    timeout                                   = 30
    unhealthy_threshold                       = 20
    pick_host_name_from_backend_http_settings = true
  }

  probe {
    interval            = 10
    name                = local.ag_probe_ingress
    path                = "/"
    port                = 8080
    protocol            = "Http"
    timeout             = 30
    unhealthy_threshold = 20
    host                = "localhost"
    match {
      status_code = ["200", "404"]
    }
  }

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  ssl_certificate {
    name     = local.ag_ssl_cert_name
    data     = module.terraform_acme_le.certificate_p12
    password = module.terraform_acme_le.certificate_p12_password
  }

  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20170401S"
  }

  tags = var.tags
}