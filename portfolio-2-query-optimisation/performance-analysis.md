# Query Optimization Evidence

For each query, save its SQL, result screenshot, and `EXPLAIN (ANALYZE, BUFFERS)` output before and after adding indexes.

| Query | Before execution ms | After execution ms | Plan change | Interpretation |
|---|---:|---:|---|---|
| Transcript | | | | |
| Average by course | | | | |
| Enrollments by department | | | | |
| Score filter | | | | |
| Missing results | | | | |

Small datasets may favor sequential scans and show no improvement. Do not invent speedups; record actual results. Benchmark multiple runs and note caching and cloud variability.
