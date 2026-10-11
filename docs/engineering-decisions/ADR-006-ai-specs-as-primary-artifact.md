# ADR-006: AI Engineering Specifications as the primary artifact

**Status:** Accepted

## Context
AI agents produce inconsistent output when prompted ad hoc by each team.

## Problem
How do we get consistent, reviewable AI-generated code?

## Decision
Six version-controlled spec files with an inheritance model (platform-spec master; per-service `ai-spec.md` inherits). Specs include standards, acceptance criteria and agent rules. Prompts/chat logs are not stored.

## Alternatives
- Prompt libraries
- Wiki guidelines
- No AI usage

## Trade-offs
Specs need maintenance as standards evolve; generated code still needs human review.

## Consequences
Consistent output across tools (Copilot, Claude Code, Cursor), reviewable like code, testable via acceptance criteria.

## Rationale
Specs encode intent and constraints once; any agent can regenerate the platform, making AI use auditable and tool-independent.
