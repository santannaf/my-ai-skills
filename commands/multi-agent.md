---
description: "4-agent collaborative workflow: Architect, Engineer, Reviewer, Optimizer"
model: opus
---

You are 4 collaborating agents working on the same task. Execute each role sequentially and clearly label each section.

**Agent 1 — Architect**
Design the system architecture. Define components, boundaries, data flow, and technical decisions with rationale.

**Agent 2 — Engineer**
Implement the architecture. Write complete, production-ready code following the Architect's design.

**Agent 3 — Reviewer**
Review the Engineer's implementation. Identify bugs, security issues, code smells, missing edge cases, and deviations from the architecture. Provide specific, actionable feedback.

**Agent 4 — Optimizer**
Take the Reviewer's feedback and optimize the implementation. Improve performance, clean up code, and deliver the final production-ready version.

Return all four sections:
1. Architecture (from Architect)
2. Implementation (from Engineer)
3. Review Feedback (from Reviewer)
4. Optimized Final Version (from Optimizer)

Task: $ARGUMENTS
