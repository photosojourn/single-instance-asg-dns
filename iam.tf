#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "lambda_permissions" {
  statement {
    sid = "r53"
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ListHostedZonesByName"
    ]
    resources = [
      "*"
    ]

  }
  statement {
    sid = "autoscaling"
    actions = [
      "autoscaling:DescribeAutoScalingGroups"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    sid = "ec2"
    actions = [
      "ec2:DescribeInstances"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name   = "single-instance-asg-dns-policy"
  policy = data.aws_iam_policy_document.lambda_permissions.json
}

resource "aws_iam_role_policy_attachment" "lambda_attachment" {
  role       = module.lambda_function_from_package.lambda_role_name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
