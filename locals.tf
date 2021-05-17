locals {
  gitlab_configuration_name = var.gitlab_configuration.name != "" ? var.gitlab_configuration_name : random_pet.gitlab_configuration_name.id
}

resource "random_pet" "gitlab_configuration_name" {
  length = 2
  separator = "-"
}