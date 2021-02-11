
vault_endpoint  = "https://vault.${prefix}.${external_domain}"
consul_endpoint = "https://consul.${prefix}.${external_domain}"
nomad_endpoint  = "https://nomad.${prefix}.${external_domain}"

%{ if use_le_staging ~}
vault_skip_tls_verify = true
consul_insecure_https = true
ca_cert_file          = "../caravan-infra-azure/ca_certs.pem"
%{ else ~}
vault_skip_tls_verify = false
consul_insecure_https = false
%{ endif ~}

bootstrap_state_backend_provider   = "azure"
auth_providers                     = ["azure"]
bootstrap_state_object_name_prefix = "infraboot/terraform/state"

azure_bootstrap_resource_group_name  = "${resource_group_name}"
azure_bootstrap_storage_account_name = "${storage_account_name}"
azure_bootstrap_client_id            = "${client_id}"
azure_bootstrap_client_secret        = "${client_secret}"
azure_bootstrap_tenant_id            = "${tenant_id}"
azure_bootstrap_subscription_id      = "${subscription_id}"
