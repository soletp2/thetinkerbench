---
title: "AI agents in a documentation pipeline: what actually works"
description: "An overview of five AI-agent capabilities we built into a docs-as-code pipeline — and the guardrails that make them safe for CI."
pubDate: 2026-03-20
tags:
  - ai
  - documentation
  - automation
---

AI in documentation pipelines is easy to demo and hard to productionize. The gap between "look, it generated a README" and "this runs safely on every CI build across 120 services" is enormous.

Here's what we built, what worked, and what required guardrails.

## Five agent capabilities

Our pipeline includes five distinct AI-agent tasks, each scoped to a specific output:

### 1. Per-service README generation

Each microservice gets a README generated from its source structure, dependencies, and entry points. The agent reads the codebase context and produces a standardized overview. This works well because READMEs have a predictable structure and tolerate minor stylistic variation.

### 2. Architecture diagramming

Service-level and system-level diagrams generated from code analysis. These are more hit-or-miss — complex dependency graphs confuse models, and diagram syntax errors break rendering. We validate output against a schema before committing.

### 3. Developer portal publishing

Automated publishing of generated docs to the internal portal. This is orchestration more than generation, but AI helps with metadata tagging and cross-linking between related services.

### 4. Business requirements extraction

REST controller logic gets analyzed to extract business requirements documentation. Useful for teams that never wrote requirements in the first place. Accuracy depends heavily on how well the code is annotated and named.

### 5. AGENT.md authoring

Standardized files that tell AI coding agents how to interpret a codebase — directory conventions, build commands, testing patterns. This is meta-documentation: docs that help other AI tools work better with your code.

## The guardrails that matter

Running agents in CI is different from running them in a chat window. You need:

**Concurrency control.** Multiple agents writing to overlapping doc paths will corrupt output. We use file-level locking and sequential processing for shared directories.

**Loop prevention.** An agent that triggers a rebuild that triggers the agent again will run forever. Our three-layer strategy: max iteration counts, change detection (did the output actually change?), and circuit breakers on repeated identical output.

**Token quotas.** Per-build and per-service limits prevent a single complex service from consuming the entire budget. Overages fail gracefully with a clear CI message.

**Output validation.** Generated Markdown and diagram syntax get validated before commit. Invalid output fails the build rather than publishing broken docs.

## What I'd tell someone starting out

Don't try to automate everything at once. Pick one high-value, low-risk output — README generation is a good starting point — and make it reliable before expanding. The agents are only as trustworthy as the guardrails around them.

And keep humans in the loop for anything that requires judgment about audience, tone, or strategic messaging. AI is excellent at extraction and formatting. It's not excellent at knowing what your developers actually need to understand.
