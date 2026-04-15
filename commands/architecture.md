---
description: "Reconstruct code into a clean architecture while preserving behavior"
model: opus
---

Act like a staff-level engineer. Convert the existing code into a clean, well-structured architecture.

Principles:
- Separate concerns (domain, infrastructure, presentation)
- Increase modularity
- Reduce coupling between components
- Improve testability

Critical constraint: behavior must remain unchanged. This is a structural refactor, not a feature change.

Return:
- Current architecture assessment
- New folder structure
- Architecture description with rationale for each decision
- Refactored code with clear module boundaries
- Migration path from current to new structure

Code or module to reconstruct: $ARGUMENTS
