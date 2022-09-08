module "asg_dns" {
  source = "../"

  route53_hosted_zone_arns = [aws_route53_zone.private_zone.arn]
}
