# ADR-002: Terraform module library with a composite golden-path module

**Status:** Accepted

## Context
Teams duplicate VPC/S3/DynamoDB Terraform with inconsistent security settings.

## Problem
How do we remove duplication yet allow fine-grained reuse?

## Decision
Small single-purpose modules (network, dynamodb-table, s3-bucket, ecr-repository, ecs-service) plus composite `app-platform` module. Consumed via git tag `?ref=`.

## Alternatives
- Single monolithic module
- Terraform Registry (private)
- Terragrunt / CDK / Pulumi

## Trade-offs
Composite hides detail (less flexibility); git-ref consumption lacks registry search UI.

## Consequences
Teams call one module (8 lines) for the standard case, or compose primitives for custom needs. Module upgrades are explicit version bumps.

## Rationale
Two-tier modules balance simplicity and flexibility. Git refs need no extra infrastructure, fitting the zero-cloud constraint. Native Terraform keeps skills portable.
