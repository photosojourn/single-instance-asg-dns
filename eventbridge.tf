resource "aws_cloudwatch_event_rule" "ec2_instance_start" {
  name        = "asg-ec2-start"
  description = "Capture ASG EC2 Instace start events"

  event_pattern = <<EOF
{
  "source": ["aws.autoscaling"],
  "detail-type": ["EC2 Instance Launch Successful"]
}
EOF
}

resource "aws_cloudwatch_event_target" "ec2_instance_start" {
  arn  = module.lambda_function_from_package.lambda_function_arn
  rule = aws_cloudwatch_event_rule.ec2_instance_start.name
}

resource "aws_lambda_permission" "allow_cloudwatch_run_lamdba_backup" {
  statement_id  = "AllowExecutionFromCloudWatchBackup"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_function_from_package.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ec2_instance_start.arn
}
