# ADR-005: Shell scaffolder now, developer portal later

**Status:** Accepted

## Context
Need self-service onboarding quickly with no extra infrastructure.

## Problem
Should we adopt Backstage/Cookiecutter now or a lightweight script?

## Decision
Ship `scripts/new-service.sh` + `templates/service-template`; revisit Backstage software templates once >10 teams.

## Alternatives
- Backstage software templates
- Cookiecutter / Copier
- GitHub template repository only

## Trade-offs
Script has no update mechanism for already-generated repos (template drift). Portal gives catalog/UI but costs hosting and maintenance.

## Consequences
Fast adoption and zero hosting. Template drift mitigated because logic lives in versioned reusable workflows/modules, not copied files.

## Rationale
Smallest solution that meets today's need; template is portable into Backstage later without rework.
