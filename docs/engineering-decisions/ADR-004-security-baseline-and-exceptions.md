# ADR-004: Shift-left security baseline with documented exceptions

**Status:** Accepted

## Context
Security checks were inconsistent or skipped under delivery pressure.

## Problem
How do we enforce security without blocking legitimate exceptions?

## Decision
Mandatory Gitleaks, Trivy (HIGH/CRITICAL) and Checkov in reusable workflows, failing closed. Exceptions allowed only in policy files with justification, owner and expiry.

## Alternatives
- Advisory-only scanning
- Central security team manual review
- Different tools per team

## Trade-offs
Some CMK/replication checks skipped for non-regulated data (cost/complexity); upgrade path documented. Possible false positives slow PRs.

## Consequences
Controls are uniform and auditable. Skipped checks are visible in one file reviewed by Security via CODEOWNERS.

## Rationale
Consistent automated gates scale better than manual review, and explicit exceptions keep pragmatism honest.
