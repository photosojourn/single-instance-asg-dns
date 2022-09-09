# single-instance-asg-dns

There are some circumstances which require the use of a single EC2 instance in an AGS, such as a monolithic application or bastion. This provides
automated failure recovery, but with the side effect of the IP address changing. To resolve this issue in instances where the IP can change, but DNS need to be updated this module uses events from the ASG in question to trigger a Lambda function to update Route53.

## Tagging requirements

In order for the Lambda function to update DNS a tag must be added to each ASG. This tag is called `asg_dns` and is the fully quailifed domain name you want the ASG instance to create/update.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
