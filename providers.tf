provider "gitlab" {
  token = var.gitlab_configuration.token
  base_url = "${var.gitlab_configuration.gitlab_host_url}/api/v4/" 
}

provider "kubernetes" {
  host                   = var.kubernetes_configuration.kubernetes_api_url
  cluster_ca_certificate = base64decode(var.kubernetes_configuration.cluster_certificate_authority_data)
  token                  = var.kubernetes_configuration.token 
}