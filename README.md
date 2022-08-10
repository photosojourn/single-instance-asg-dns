# Single Instance ASG DNS

This lambda function is designed to handle the updating of a DNS record for an ASG which contains only a single instance
i.e Bastion or Instance which is part of a partioned cluster.

## Repo

* Precommit Hooks for the following:
  * flake8 - Python linting
  * Black - Python file formatting
  * hadolint - Docker file liniting
