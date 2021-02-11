
vault_endpoint  = "https://vault.${prefix}.${external_domain}"
consul_endpoint = "https://consul.${prefix}.${external_domain}"
nomad_endpoint  = "https://nomad.${prefix}.${external_domain}"
domain          = "${external_domain}"

%{ if use_le_staging ~}
vault_skip_tls_verify = true
consul_insecure_https = true
ca_cert_file          = "../caravan-infra-azure/ca_certs.pem"
%{ else ~}
vault_skip_tls_verify = false
consul_insecure_https = false
%{ endif ~}

artifacts_source_prefix = ""
services_domain         = "service.consul"
dc_names                = ["${dc_name}"]
github_shared_secret    = ""
github_token            = ""
