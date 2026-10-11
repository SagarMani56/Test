# ADR-001: Reusable workflows over copied pipelines

**Status:** Accepted

## Context
Each team copy-pasted ~100 lines of CI YAML and drifted over time.

## Problem
How do we share CI/CD logic while letting teams customize inputs?

## Decision
Central repo of GitHub `workflow_call` reusable workflows, versioned by tag; app repos hold thin callers.

## Alternatives
- Composite actions only
- Copy template pipelines per repo
- Org-level required workflows (rulesets)

## Trade-offs
Teams cannot change steps, only inputs (intended). Platform team becomes a dependency for pipeline changes.

## Consequences
One fix propagates to all teams on version bump; callers shrink to <=20 lines; breaking changes need a major tag.

## Rationale
Reusable workflows give job-level reuse with permissions control and secrets passthrough, which composite actions (step-level) lack. Copying is the root cause of the problem.
