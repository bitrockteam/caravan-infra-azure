
vault_endpoint  = "https://vault.${prefix}.${external_domain}"
consul_endpoint = "https://consul.${prefix}.${external_domain}"
nomad_endpoint  = "https://nomad.${prefix}.${external_domain}"
domain          = "${external_domain}"

%{ if use_le_staging ~}
vault_skip_tls_verify = true
consul_insecure_https = true
ca_cert_file          = "../caravan-infra-azure/ca_certs.pem"
configure_grafana     = false
%{ else ~}
vault_skip_tls_verify = false
consul_insecure_https = false
configure_grafana     = true
%{ endif ~}

services_domain            = "service.consul"
dc_names                   = ["${dc_name}"]
cloud                      = "azure"
artifacts_source_prefix    = ""
jenkins_volume_external_id = "${jenkins_volume_id}"
container_registry         = ""
azure_tenant_id            = "${tenant_id}"
azure_subscription_id      = "${subscription_id}"
