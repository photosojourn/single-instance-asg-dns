# single-instance-asg-dns

There are some circumstances which require the use of a single EC2 instance in an AGS, such as a monolithic application or bastion. This provides
automated failure recovery, but with the side effect of the IP address changing. To resolve this issue in instances where the IP can change, but DNS need to be updated this module uses events from the ASG in question to trigger a Lambda function to update Route53.

## Tagging requirements

In order for the Lambda function to update DNS a tag must be added to each ASG. This tag is called `asg_dns` and is the fully quailifed domain name you want the ASG instance to create/update.

## Know Issues

While a `depends_on` statement can be used to control the deployment of the Lambda function prior to the ASG (see example), there is a still a chance that the ASG will launch the first instance before the Lambda function has been provisioned for the first time. This situation means that the DNS record may not always be created as part of the inital `terraform apply`. This is out of our control so the best resolution is to simply terminate the first instance and allow the ASG to launch a fresh one. This will result in the DNS entry being created as everything is now in place.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda_function_from_package"></a> [lambda\_function\_from\_package](#module\_lambda\_function\_from\_package) | terraform-aws-modules/lambda/aws | v4.0.1 |
| <a name="module_package_dir"></a> [package\_dir](#module\_package\_dir) | terraform-aws-modules/lambda/aws | v4.0.1 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.ec2_instance_start](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.ec2_instance_start](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_policy.lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_permission.allow_cloudwatch_run_lamdba_backup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_iam_policy_document.lambda_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_route53_hosted_zone_arns"></a> [route53\_hosted\_zone\_arns](#input\_route53\_hosted\_zone\_arns) | List of Hosted Zone ARNs which the Lambda can use | `list(string)` | `[]` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
