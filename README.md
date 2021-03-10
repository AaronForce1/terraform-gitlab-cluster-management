# infrastructure-terraform-eks

[![LICENSE](https://img.shields.io/badge/license-Apache_2-blue)](https://opensource.org/licenses/Apache-2.0)

A custom-build terraform module, leveraging terraform-aws-eks to create a managed Kubernetes cluster on AWS EKS. In addition to provisioning simply an EKS cluster, this module alongside additional components to complete an entire end-to-end base stack for a functional kubernetes cluster for development and production level environments, including a base set of software that can/should be commonly used across all clusters. Primary integrated sub-modules include:
- [AWS EKS Terraform Module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws)
- [AWS VPC Terraform Module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws)

## Assumptions

* You want to create an EKS cluster and an autoscaling group of workers for the cluster.
* You want these resources to exist within security groups that allow communication and coordination.
* You want to generate an accompanying Virtual Private Cloud (VPC) and subnets where the EKS resources will reside. The VPC satisfies [EKS requirements](https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html).
* You want specific security provisions in place, including the use of private subnets for all nodes.
* The base ingress controller to be used is Nginx-Ingress Controller with internet-facing AWS network load balancers instead of being controlled by more reactive AWS Application Load Balancers.


## Important note

The `cluster_version` is the required variable. Kubernetes is evolving a lot, and each major version includes new features, fixes, or changes.

**Always check [Kubernetes Release Notes](https://kubernetes.io/docs/setup/release/notes/) before updating the major version.**

You also need to ensure your applications and add ons are updated, or workloads could fail after the upgrade is complete. For action, you may need to take before upgrading, see the steps in the [EKS documentation](https://docs.aws.amazon.com/eks/latest/userguide/update-cluster.html).

An example of harming update was the removal of several commonly used, but deprecated  APIs, in Kubernetes 1.16. More information on the API removals, see the [Kubernetes blog post](https://kubernetes.io/blog/2019/07/18/api-deprecations-in-1-16/).

For windows users, please read the following [doc](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/faq.md#deploying-from-windows-binsh-file-does-not-exist).

## Usage

### Provisioning Sequence

1. Once AWS Credentials (see notes below) are set up on your local machine, it is recommended to follow docker-compose command in order to initialise terraform state within the context of Gitlab. However, you can also manage terraform state in other ways. An example of initialising terraform with a gitlab-managed state is shown here:
```
export TF_ADDRESS=${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/terraform/state/${TF_VAR_app_name}-${TF_VAR_app_namespace}-${TF_VAR_tfenv} && \ 
terraform init \
  -backend-config="address=${TF_ADDRESS}" \
  -backend-config="lock_address=${TF_ADDRESS}/lock" \
  -backend-config="unlock_address=${TF_ADDRESS}/lock" \
  -backend-config="username=${TF_VAR_gitlab_username}" \
  -backend-config="password=${TF_VAR_gitlab_token}" \
  -backend-config="lock_method=POST" \
  -backend-config="unlock_method=DELETE" \
  -backend-config="retry_wait_min=5"
```
2. `terraform plan`
3. `terraform apply`
4. `terraform destroy`


## Other documentation

* [Autoscaling](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/autoscaling.md): How to enable worker node autoscaling.
* [Enable Docker Bridge Network](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/enable-docker-bridge-network.md): How to enable the docker bridge network when using the EKS-optimized AMI, which disables it by default.
* [Spot instances](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/spot-instances.md): How to use spot instances with this module.
* [IAM Permissions](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/iam-permissions.md): Minimum IAM permissions needed to setup EKS Cluster.
* [FAQ](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/faq.md): Frequently Asked Questions

## Doc generation

Code formatting and documentation for variables and outputs is generated using [pre-commit-terraform hooks](https://github.com/antonbabenko/pre-commit-terraform) which uses [terraform-docs](https://github.com/segmentio/terraform-docs).

Follow [these instructions](https://github.com/antonbabenko/pre-commit-terraform#how-to-install) to install pre-commit locally.

And install `terraform-docs` with `go get github.com/segmentio/terraform-docs` or `brew install terraform-docs`.

## Contributing

Report issues/questions/feature requests on in the [issues](https://gitlab.com/magnetic-asia/infrastructure-as-code/infrastructure-terraform-eks/issues/new) section.

Full contributing [guidelines are covered here](https://gitlab.com/magnetic-asia/infrastructure-as-code/infrastructure-terraform-eks/blob/master/.github/CONTRIBUTING.md).

## Change log

- The [changelog](https://gitlab.com/magnetic-asia/infrastructure-as-code/infrastructure-terraform-eks/tree/master/CHANGELOG.md) captures all important release notes from 1.1.17

## Authors

Created by [Aaron Baideme](https://gitlab.com/aaronforce1) - aaron.baideme@magneticasia.com

Supported by Ronel Cartas - ronel.cartas@magneticasia.com

## License

MIT Licensed. See [LICENSE](https://gitlab.com/magnetic-asia/infrastructure-as-code/infrastructure-terraform-eks/tree/master/LICENSE) for full details.

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