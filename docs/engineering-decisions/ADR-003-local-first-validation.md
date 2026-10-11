# ADR-003: Local-first validation with LocalStack and Docker

**Status:** Accepted

## Context
Capstone rules say cloud accounts may not be provided; solution must be reproducible without cloud.

## Problem
How do we prove IaC and pipelines work without AWS?

## Decision
Use LocalStack (community) for S3/DynamoDB/VPC apply; `terraform validate` + Checkov for ECR/ECS; Docker for app; GitHub Actions or YAML lint for workflows.

## Alternatives
- Real AWS sandbox
- Terraform plan only
- Mocking providers

## Trade-offs
LocalStack community does not emulate all services (ECS/ECR); those get static validation only. Slight behavior drift from real AWS.

## Consequences
Anyone can reproduce results with Docker. Real-AWS path is a flag (`use_localstack=false`, `enable_compute=true`).

## Rationale
Gives real apply/destroy evidence for core modules at zero cost while being transparent about coverage gaps.
