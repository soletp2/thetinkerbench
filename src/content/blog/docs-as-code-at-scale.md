---
title: "Docs-as-code at scale: lessons from 120 microservices"
description: "What I learned building a CI/CD pipeline that regenerates developer documentation on every build across a large microservices platform."
pubDate: 2026-05-15
tags:
  - docs-as-code
  - ci-cd
  - technical-writing
---

When documentation lives outside the codebase, it drifts. When it lives inside the repo but updates manually, it still drifts — just more slowly. The only sustainable model I've found at scale is **docs-as-code with automated regeneration on every build**.

## The problem at scale

A platform with 120 microservices doesn't have a documentation problem — it has a **synchronization problem**. Every API change, every new endpoint, every renamed field creates a gap between what the code does and what the docs say. Multiply that by dozens of teams shipping weekly, and manual updates become impossible.

The goal isn't to eliminate human judgment from documentation. It's to eliminate the mechanical work that humans shouldn't be doing: copying endpoint signatures, updating version numbers, regenerating reference tables.

## What the pipeline does

Our CI/CD integration runs on every build and:

1. Detects which services changed since the last run
2. Regenerates API references from source annotations
3. Runs AI agents for READMEs, architecture diagrams, and conceptual summaries
4. Publishes updated docs to the internal developer portal
5. Fails the build if generated output diverges from committed docs (drift detection)

That last step is critical. Without a guardrail, teams learn to ignore documentation failures. With it, documentation becomes a first-class build artifact.

## Reliability is not optional

Running automation on every CI execution means failures can't be flaky. We invested heavily in:

- **Concurrency handling** — parallel writes to the same doc set need coordination
- **Loop prevention** — AI agents that trigger rebuilds that trigger agents need circuit breakers
- **Token quotas** — unbounded LLM calls in CI will eventually bankrupt your pipeline budget

These aren't glamorous problems, but they're the difference between a pipeline teams trust and one they disable.

## The takeaway

Docs-as-code at scale isn't about choosing Markdown over a wiki. It's about treating documentation as a **build artifact** with the same rigor you apply to tests and deployments. Start with one service, prove the loop works, then expand. The hardest part is cultural — getting teams to accept that docs can and should be generated.
