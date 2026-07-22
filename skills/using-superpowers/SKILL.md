---
name: using-superpowers
description: Use when starting any conversation - establishes how to find and use skills
---

<SUBAGENT-STOP>
If you were dispatched as a subagent to execute a specific task, ignore this skill.
</SUBAGENT-STOP>

# Using Superpowers

Before starting a task, check whether a skill matches it. If one clearly
applies, read it and follow it; announce "Using [skill] to [purpose]". If it
turns out to be wrong for the situation, say so and proceed without it.

## Routing

- New feature or ambiguous scope → brainstorming (research-first design)
- A written plan exists → executing-plans (default); subagent-driven-development
  only for multi-task isolation, high-risk changes, or explicit user request
- Behavior change → test-driven-development
- Complex or recurring bug → systematic-debugging
- Before claiming work is done → verification-before-completion

Process skills set the approach; implementation skills carry it out.

## Platform Adaptation

If your harness appears here, read its reference file for special instructions:

- Codex: `references/codex-tools.md`
- Pi: `references/pi-tools.md`
- Antigravity: `references/antigravity-tools.md`

## Priority

User instructions (CLAUDE.md, AGENTS.md, direct requests) take precedence over
skills, which in turn override default behavior.
