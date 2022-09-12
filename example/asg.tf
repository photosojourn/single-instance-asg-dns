module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "v6.5.2"

  # Autoscaling group
  name = "single-instance-asg-dns-test-asg"

  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = module.vpc.private_subnets

  launch_template_name        = "single-instance-asg-dns-test-asg"
  launch_template_description = "Launch template example"
  update_default_version      = true

  image_id          = "ami-0768c1f18418e882d"
  instance_type     = "t3.micro"
  ebs_optimized     = true
  enable_monitoring = true

  # IAM role & instance profile
  create_iam_instance_profile = false

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 32
    instance_metadata_tags      = "enabled"
  }

  tags = {
    asg_dns = var.asg_dns
  }

  depends_on = [
    module.asg_dns
  ]
}
