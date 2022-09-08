variable "route53_hosted_zone_arns" {
  description = "List of Hosted Zone ARNs which the Lambda can use"
  type        = list(string)
  default     = []
}
