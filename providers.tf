provider "gitlab" {
  token = var.gitlab_configuration.token
}

provider "kubernetes" {
  host                   = var.kubernetes_configuration.kubernetes_api_url
  cluster_ca_certificate = base64decode(var.kubernetes_configuration.cluster_certificate_authority_data)
  token                  = var.kubernetes_configuration.token
}