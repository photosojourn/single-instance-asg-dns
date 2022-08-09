# AWS Lambda Python Template

This repo provides a opinunated "best practice" template for AWS Lambda functions using
the Python language.

## Features

### Python
* Inclusion of [Lambda Powertools Python](https://awslabs.github.io/aws-lambda-powertools-python/latest/)
* Logging already configured
* Tracing using AWS XRay configured and enabled via envrioment variable `ENABLE_XRAY` (True or False, default False)
* Python Typing for ease of readability

### Repo
* Precommit Hooks for the following:
  * flake8 - Python linting
  * Black - Python file formatting
  * hadolint - Docker file liniting
