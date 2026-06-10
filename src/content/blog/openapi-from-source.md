---
title: "Why generating OpenAPI from annotated Java beats manual contracts"
description: "How a custom Gradle plugin eliminated manual API-contract authoring across 85 REST services."
pubDate: 2026-04-28
tags:
  - openapi
  - api-documentation
  - automation
---

Manual OpenAPI authoring doesn't scale. I've watched teams maintain Swagger files that diverged from their actual REST controllers within a single sprint. The contract becomes fiction, and developers stop trusting it.

## The manual contract trap

When API contracts are written separately from code, three things happen:

1. Developers change the API and forget to update the spec
2. Technical writers update the spec without understanding runtime behavior
3. The spec becomes a negotiation document rather than a source of truth

None of this is malice — it's the natural result of maintaining two sources of truth.

## Generate from source

We built a custom Gradle plugin with a Groovy plugin layer and core generation logic in Java. It reads annotations on REST controllers and produces OpenAPI contracts automatically. The plugin runs as part of the standard build, so every developer generates an up-to-date contract without thinking about it.

The key design decisions:

- **Annotations as the contract language** — developers already annotate controllers; we extend that vocabulary rather than introducing a parallel authoring workflow
- **Build-time generation** — the contract is always derived from what compiles, not what someone remembered to write
- **CI enforcement** — if generated output differs from committed files, the build fails

Across 85 REST services, this removed an entire category of manual work and eliminated an entire category of drift.

## What about the human role?

Generating contracts doesn't replace technical writers. It changes what they do. Instead of transcribing endpoints, writers focus on:

- Conceptual documentation explaining *why* an API works the way it does
- Getting-started guides with realistic examples
- Error handling patterns and troubleshooting flows
- Information architecture across service boundaries

The generated reference is the floor, not the ceiling.

## When generation isn't enough

Some API designs need narrative context that annotations can't capture — deprecation stories, migration paths, breaking change rationale. We handle this with supplementary Markdown files that sit alongside generated output and get merged at publish time.

The principle remains: **automate what is mechanical, invest human effort where judgment matters.**
