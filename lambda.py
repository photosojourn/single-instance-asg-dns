"""
Lambda function template
"""
import os
from typing import Any, Dict
from aws_lambda_powertools.utilities.typing import LambdaContext
from aws_lambda_powertools import Logger
from aws_lambda_powertools import Tracer

# from aws_lambda_powertools.utilities import parameters  #Allows access to SSM and Secrets Mgr

service_name = "my-service"  # Set service name used by Logger/Tracer here

logger = Logger(service=service_name)
tracer = Tracer(service=service_name, disabled=bool(os.environ["ENABLE_XRAY"]))
aws_region = os.environ["AWS_REGION"]


@logger.inject_lambda_context
@tracer.capture_lambda_handler
def lambda_handler(event: Dict[str, Any], context: LambdaContext) -> Dict[str, Any]:
    """
    Main Lambda entry point.

    Parameters
    ----------
    event: Lambda event object
    context: Lambda context object
    """
    logger.info("Something did something")
    return {"statusCode": 200}
