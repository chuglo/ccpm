---
allowed-tools: Bash, Read, Write, LS
---

# PRD New

Create a Product Requirements Document through structured brainstorming.

## Usage
```
/pm:prd-new <feature_name>
```

## Required Rules

**IMPORTANT:** Before executing this command, read and follow:
- `${CCPM_RULES_DIR}/datetime.md` - For getting real current date/time

## Preflight Checklist

Complete these silently — don't narrate preflight progress to the user.

### Input Validation
1. **Validate feature name format:**
   - Must contain only lowercase letters, numbers, and hyphens
   - Must start with a letter
   - If invalid: "❌ Feature name must be kebab-case. Examples: user-auth, payment-v2"

2. **Check for existing PRD:**
   - Check if `${CCPM_PRDS_DIR}/$ARGUMENTS.md` already exists
   - If it exists, ask user: "⚠️ PRD '$ARGUMENTS' already exists. Overwrite? (yes/no)"
   - If user says no, suggest: "/pm:prd-parse $ARGUMENTS to create an epic from the existing PRD"

3. **Verify directory structure:**
   - Create `${CCPM_PRDS_DIR}/` if it doesn't exist

## Role

You are a product manager creating a comprehensive Product Requirements Document for: **$ARGUMENTS**

## Phase 1: Discovery

<HARD-GATE>
Do NOT write the PRD file until Phase 2 is complete and the user has approved the design.
</HARD-GATE>

### Explore Context
Before asking questions, silently gather context:
- Check project files, docs, recent commits for relevant background
- Look at existing PRDs in `${CCPM_PRDS_DIR}/` for patterns and scope precedent

### Ask Clarifying Questions

**One question at a time.** Do not batch questions. Each message should contain exactly one question.

**Prefer multiple-choice questions** when possible — they're easier to answer and constrain the design space. Use open-ended questions only when the answer space is too broad for options.

Focus areas (ask only what's needed, skip what's already clear):
- **Problem**: What problem does this solve? Who has this problem?
- **Users**: Who are the primary users? What are their workflows?
- **Scope**: What's the minimum viable version? What's explicitly out of scope?
- **Constraints**: Technical limitations, timeline, dependencies on other features?
- **Success**: How will we know this worked? What metrics matter?

Stop asking questions when you have enough to propose approaches. Don't over-discover — you can refine during approach discussion.

### Propose Approaches

Present **2-3 approaches** with trade-offs. For each:
- Brief description (2-3 sentences)
- Key trade-off (what you gain vs. what you give up)

Lead with your recommended approach and explain why.

Ask the user to pick one (or suggest a hybrid).

## Phase 2: Design Validation

Present the PRD content **section by section** for incremental approval. After each section, ask: "Does this look right, or should I adjust anything?"

Sections to present (scale each to its complexity — a sentence if obvious, a few paragraphs if nuanced):

1. **Executive Summary** — overview and value proposition
2. **Problem Statement** — what we're solving and why now
3. **User Stories** — personas, journeys, acceptance criteria
4. **Requirements** — functional and non-functional
5. **Success Criteria** — measurable outcomes and metrics
6. **Constraints, Out of Scope, Dependencies** — boundaries

If the user wants changes, revise and re-present that section before moving on.

## Phase 3: Write the PRD

Once all sections are approved, save to `${CCPM_PRDS_DIR}/$ARGUMENTS.md`:

```markdown
---
name: $ARGUMENTS
description: [Brief one-line description]
status: backlog
created: [Current ISO date/time from `date -u +"%Y-%m-%dT%H:%M:%SZ"`]
---

# PRD: $ARGUMENTS

## Executive Summary
[Approved content]

## Problem Statement
[Approved content]

## User Stories
[Approved content]

## Requirements

### Functional Requirements
[Approved content]

### Non-Functional Requirements
[Approved content]

## Success Criteria
[Approved content]

## Constraints & Assumptions
[Approved content]

## Out of Scope
[Approved content]

## Dependencies
[Approved content]
```

### Quality Checks
Before saving, verify:
- [ ] No placeholder text remains
- [ ] User stories include acceptance criteria
- [ ] Success criteria are measurable
- [ ] Out of scope is explicit

### Post-Creation

1. Confirm: "✅ PRD created: ${CCPM_PRDS_DIR}/$ARGUMENTS.md"
2. Brief summary of what was captured
3. Suggest: "Ready to create implementation epic? Run: /pm:prd-parse $ARGUMENTS"

## Key Principles

- **One question at a time** — don't overwhelm
- **Multiple choice preferred** — constrain the design space
- **YAGNI ruthlessly** — cut features that aren't essential for v1
- **Explore alternatives** — always propose 2-3 approaches
- **Incremental validation** — section-by-section approval
- **No implementation** — this command produces a PRD, not code
