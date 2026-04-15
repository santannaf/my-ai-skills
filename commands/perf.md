---
description: "Optimize code for speed, memory usage, and scalability"
model: sonnet
---

Act like a performance engineer. Optimize the given code with these goals:
- Speed (reduce latency and execution time)
- Memory usage (reduce allocations and footprint)
- Scalability (handle the increasing load)

Identify:
- Bottlenecks (CPU, I/O, memory)
- Inefficient algorithms or data structures
- Unnecessary computations or redundant operations
- N+1 queries, missing indexes, or unoptimized DB access

Return:
- Analysis of current performance issues with impact assessment
- Explanation of each optimization and why it matters
- Optimized code with before/after comparison
- Expected performance gains

Code or area to optimize: $ARGUMENTS
