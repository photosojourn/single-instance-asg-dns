variable "region" {
  description = "Which Region to deploy into"
  type        = string
  default     = "eu-west-2"
}

variable "vpc_domain" {
  description = "internal domain name for VPC"
  type        = string
  default     = "asg-test.internal"
}

variable "asg_dns" {
  description = "domain name for asg"
  type        = string
  default     = "volt.asg-test.internal"
}
