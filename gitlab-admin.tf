# GITLAB MANAGED APPS INTEGRATION
resource "kubernetes_service_account" "gitlab-admin" {
  metadata {
    name      = "gitlab-admin"
    namespace = "kube-system"
  }
}

resource "kubernetes_secret" "gitlab-admin" {
  metadata {
    name      = "gitlab-admin"
    namespace = "kube-system"
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.gitlab-admin.metadata.0.name
    }
  }
  lifecycle {
    ignore_changes = [
      data
    ]
  }
  type = "kubernetes.io/service-account-token"
}

data "kubernetes_secret" "gitlab-admin-token" {
  metadata {
    name      = kubernetes_service_account.gitlab-admin.default_secret_name
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "gitlab-admin" {
  metadata {
    name = "gitlab-admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "gitlab-admin"
    namespace = "kube-system"
  }
}

# GITLAB K8S ENV INTEGRATION
data "gitlab_group" "gitops_namespace" {
  full_path = var.gitlab_configuration.group
}

resource "gitlab_group_cluster" "cluster" {
  group              = data.gitlab_group.gitops_namespace.id
  name               = var.kubernetes_configuration.cluster_name
  domain             = var.cluster_domain
  environment_scope  = var.gitlab_configuration.cluster_environment_scope
  kubernetes_api_url = var.kubernetes_configuration.kubernetes_api_url
  kubernetes_token   = data.kubernetes_secret.gitlab-admin-token.data.token
  kubernetes_ca_cert = trimspace(base64decode(var.kubernetes_configuration.cluster_certificate_authority_data))

}

resource "null_resource" "gitlab-management-cluster-associate" {
  triggers = { cluster_id = gitlab_group_cluster.cluster.id }

  provisioner "local-exec" {
    command = local.curl_cmd
  }
  depends_on = [gitlab_group_cluster.cluster]
}

# Work Around for lack of `management_project_id` in gitlab_group_cluster
locals {
  group_cluster_api_url = join("", [var.gitlab_configuration.gitlab_host_url, "/groups/", gitlab_group_cluster.cluster.group, "/clusters/", split(":", gitlab_group_cluster.cluster.id)[1]])
  curl_cmd = join("", [
    "curl -s --header \"Private-Token: ",
    var.gitlab_configuration.token,
    "\" ",
    local.group_cluster_api_url,
    " -H 'Content-Type:application/json' --request PUT --data '{\"management_project_id\":\"'",
    var.gitlab_configuration.cluster_management_project_id,
    "'\"}'"
  ])
}