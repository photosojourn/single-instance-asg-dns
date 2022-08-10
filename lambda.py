"""
Single Instance ASG DNS
"""
import os
import boto3
from typing import Dict, Any
from urllib.parse import urlparse
from aws_lambda_powertools.utilities.typing import LambdaContext
from aws_lambda_powertools import Logger
from aws_lambda_powertools import Tracer
from aws_lambda_powertools.utilities.data_classes import event_source, EventBridgeEvent


service_name = "single-instance-asg-dns"  # Set service name used by Logger/Tracer here

logger = Logger(service=service_name)
tracer = Tracer(service=service_name, disabled=bool(os.environ["ENABLE_XRAY"]))

ec2 = boto3.client("ec2")
autoscaling = boto3.client("autoscaling")
r53 = boto3.client("route53")


def fetch_asg_desired_state(asg_name) -> int:
    asg = autoscaling.describe_auto_scaling_groups(AutoScalingGroupNames=[asg_name])

    return asg["AutoScalingGroups"][0]["DesiredCapacity"]


def fetch_ip_from_ec2(instance_id: str) -> str:
    """
    Fetches either Public or Private IP for an EC2 instance

    Parameters
    ----------
    instance_id: Instance ID of the EC2 instance
    """
    logger.info("Fetching IP for instance-id: %s", instance_id)
    ip_address = None
    ec2_response = ec2.describe_instances(InstanceIds=[instance_id])["Reservations"][0][
        "Instances"
    ][0]

    if ec2_response["State"]["Name"] == "running":
        try:
            ip_address = ec2_response["PrivateIpAddress"]
            logger.info(
                "Found private IP for instance-id %s: %s", instance_id, ip_address
            )
        except Exception as e:
            logger.error(e)

    return ip_address


def fetch_asg_dns(asg_name: str) -> str:
    """
    Fetches the dns name used for the ASG

    Parameters
    ----------
    asg_name: Name of the ASG to get domain name for
    """
    asg = autoscaling.describe_auto_scaling_groups(AutoScalingGroupNames=[asg_name])

    tags = asg["AutoScalingGroups"]["Tags"]
    return next(item for item in tags if item["Key"] == "asg_dns").get("Value")


def update_dns(ip_addr: str, asg: str):
    """
    Updates DNS record for ASG

    Parameters
    ----------
    ip_addr: IP Address to update DNS with
    asg: Name of the ASG
    """
    dns = fetch_asg_dns(asg)
    hosted_zones = r53.list_hosted_zones_by_name(
        DNSName=".".join(urlparse(dns).path.split(".")[1:])
    )

    zone_id = hosted_zones["HostedZones"][0]["Id"].split("/")[1]

    r53.change_resource_record_sets(
        HostedZoneId=zone_id,
        ChangeBatch={
            "Changes": [
                {
                    "Action": "UPSERT",
                    "ResourceRecordSet": {
                        "Name": dns,
                        "Type": "A",
                        "TTL": 300,
                        "ResourceRecords": [
                            {
                                "Value": ip_addr,
                            }
                        ],
                    },
                }
            ]
        },
    )


@logger.inject_lambda_context
@tracer.capture_lambda_handler
@event_source(data_class=EventBridgeEvent)
def lambda_handler(event: EventBridgeEvent, context: LambdaContext) -> Dict[str, Any]:
    """
    Main Lambda entry point.

    Parameters
    ----------
    event: Lambda event object
    context: Lambda context object
    """
    logger.info("Processing Event for ASG " + event.detail["AutoScalingGroupName"])

    # This is only designed to work with one instance in the ASG
    if fetch_asg_desired_state(event.detail["AutoScalingGroupName"]) > 1:
        logger.error("ASG has a desired count greater than 1. Aborting.")
        return {"statusCode": 500}

    if event.detail["LifecycleTransition"] == "autoscaling:EC2_INSTANCE_LAUNCHING":
        ip_address = fetch_ip_from_ec2(event.detail["EC2InstanceId"])
        update_dns(ip_address, event.detail["AutoScalingGroupName"])

    return {"statusCode": 200}
