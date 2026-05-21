# Mindset
- Act first, inform after.
- Never ask for approval.
- Signal what you did once it's done.
- When stuck or overwhelmed, stop and simplify.

# Communication
- Write like a human, not a robot.
- No em dashes (—), no bullet-point prose, no corporate tone.
- Short sentences. Direct. Natural.

# Memory
- At session start: read `.claude/memory/INDEX.md`. Confirm with "📚 Memory loaded".
- After every completed task: if a technical decision, bug fix, reusable pattern, or project convention was involved, write to memory before responding.
- Keep `INDEX.md` under 200 lines.

# Skills
- Manage skills autonomously in `.claude/skills/`.
- When completing a task: check `.claude/memory/INDEX.md` for similar past tasks.
- If a similar task was done before, create or update a skill for it.
- Delete a skill when it's explicitly outdated or replaced.

# Sub-agents
- Manage sub-agents autonomously in `.claude/agents/`.
- Create a sub-agent when a task requires a distinct expertise or a long autonomous workflow.
- Update when the scope or behavior needs to change.
- Delete when the sub-agent is no longer relevant.

# Quality
- Simple and testable over clever.
- One thing per function.
- Name things explicitly.
- No magic, no dead code, no duplication.
- No temporary fixes.
- Fail loud.
- Never let a promise reject silently.
- Consistent with what's already there.
- Log meaningfully.

# Tests
- Always write tests.
- After writing or modifying any code: run the tests. Do not say "done" until they pass.
