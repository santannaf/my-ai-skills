---
description: "Implement pagination in this project. Always use keyset pagination (seek method) instead of offset-based pagination for SQL queries, Spring Data repositories, and API endpoints."
---

## Keyset Pagination (No Offset)

When implementing any form of pagination in this project, NEVER use offset-based pagination.
Always use keyset pagination (also known as seek method or cursor-based pagination).

### Why

- OFFSET forces the database to fetch and discard N rows — performance degrades linearly with page depth
- OFFSET causes duplicates or skipped rows when data is inserted between page fetches
- Keyset pagination has constant performance regardless of page depth

### SQL Pattern

Instead of:
```sql
-- NEVER do this
SELECT * FROM orders ORDER BY created_at DESC LIMIT 10 OFFSET 1000;
```

Do this:
```sql
-- Always use keyset pagination
SELECT * FROM orders
 WHERE created_at < ?last_seen_created_at
 ORDER BY created_at DESC
 FETCH FIRST 10 ROWS ONLY;
```

For multi-column sorting, use row value comparison:
```sql
SELECT * FROM orders
 WHERE (created_at, id) < (?last_seen_created_at, ?last_seen_id)
 ORDER BY created_at DESC, id DESC
 FETCH FIRST 10 ROWS ONLY;
```

### Spring Data JPA

Use `ScrollPosition` and `KeysetScrollPosition` from Spring Data:
```java
WindowIterator orders = WindowIterator.of(
    position -> orderRepository.findAllByStatusOrderByCreatedAtDesc(
        status, PageRequest.ofSize(20), position
    )
).startingAt(ScrollPosition.keyset());
```

### API Contract

Expose cursor-based pagination in REST endpoints:
GET /api/orders?size=20
GET /api/orders?size=20&after=eyJjcmVhdGVkX2F0IjoiMjAyNS0wMS0wMSIsImlkIjoiYWJjMTIzIn0=

Response must include:
```json
{
  "data": [...],
  "next_cursor": "eyJjcmVhdGVkX2F0IjoiMjAyNS0wMS0wMSIsImlkIjoiYWJjMTIzIn0=",
  "has_next": true
}
```

The cursor is a Base64-encoded JSON with the keyset values. Never expose raw IDs or timestamps as cursor — always encode.

### Index Requirement

Every keyset pagination query MUST have a composite index that matches the ORDER BY clause:
```sql
CREATE INDEX idx_orders_created_at_id ON orders (created_at DESC, id DESC);
```

### Rules

1. Never use OFFSET, LIMIT with two parameters, or row_number() for pagination
2. Always include a unique tiebreaker column (usually `id`) as the last sort key
3. Always ensure a corresponding index exists for the keyset columns
4. Encode cursors as opaque tokens — clients must not parse or construct them
5. Return `has_next` by fetching N+1 rows and returning only N
