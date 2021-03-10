# infrastructure-gitlab-clustermanagement

[![LICENSE](https://img.shields.io/badge/license-MIT-blue)](https://opensource.org/licenses/MIT)

Terraform Module configured to integrate a cloud kubernetes cluster to Gitlab for Cluster Management and deployment processes.

## Usage

## Contributing

Report issues/questions/feature requests on in the [issues](https://gitlab.com/magnetic-asia/infrastructure-as-code/infrastructure-gitlab-clustermanagement/issues/new) section.

Full contributing [guidelines are covered here](https://gitlab.com/magnetic-asia/infrastructure-as-code/infrastructure-gitlab-clustermanagement/blob/master/.gitlab/CONTRIBUTING.md).

## Change log

- The [changelog](https://gitlab.com/magnetic-asia/infrastructure-as-code/infrastructure-gitlab-clustermanagement/tree/master/CHANGELOG.md) captures all important release notes from 1.1.17

## Authors

Created by [Aaron Baideme](https://gitlab.com/aaronforce1) - aaron.baideme@magneticasia.com

Supported by Ronel Cartas - ronel.cartas@magneticasia.com

## License

MIT Licensed. See [LICENSE](https://gitlab.com/magnetic-asia/infrastructure-as-code/infrastructure-gitlab-clustermanagement/tree/master/LICENSE) for full details.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14 |

## Providers

| Name | Version |
|------|---------|
| gitlab | n/a |
| kubernetes | n/a |
| null | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [gitlab_group](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/data-sources/group) |
| [gitlab_group_cluster](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/group_cluster) |
| [kubernetes_cluster_role_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) |
| [kubernetes_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/secret) |
| [kubernetes_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) |
| [kubernetes_service_account](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) |
| [null_resource](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_domain | Optional Cluster Domain to be used as a base mapping for Gitlab Environments | `string` | `"example.com"` | no |
| gitlab\_configuration | Gitlab Configuration Object: Token, Gitlab Group for Kubernetes Cluster integration, and environment scope. | <pre>object({<br>    gitlab_host_url               = string<br>    token                         = string<br>    group                         = string<br>    cluster_environment_scope     = string<br>    cluster_management_project_id = string<br>  })</pre> | n/a | yes |
| kubernetes\_configuration | Kubernetes configuration required to bind the cluster into gitlab with management capabilities | <pre>object({<br>    cluster_name                       = string<br>    kubernetes_api_url                 = string<br>    cluster_certificate_authority_data = string<br>  })</pre> | n/a | yes |

## Outputs

No output.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->