# Activity 2: Query Processing and Optimisation — Performance Analysis

**Course:** MIT 8103 – Advanced Database Systems  
**Case study:** University Student Academic Management and Results Portal  
**Student:** Sochima Ifedikwa  
**Student ID:** 301900654  
**DBMS:** PostgreSQL (Neon)  
**Database:** `university_academic_db`

## 1. Objective

This activity investigates how PostgreSQL executes five representative academic-management queries and evaluates observed execution times before and after creating additional indexes. Query plans were captured with `EXPLAIN (ANALYZE, BUFFERS)`. The purpose is to compare measured runtime and physical execution strategies, while distinguishing correlation from evidence that a particular index caused an improvement.

## 2. Method and Evidence

Five queries were executed and their query plans captured in pgAdmin. The screenshots named `query1_analysis.png` through `query5_analysis.png` are treated as the **baseline** measurements; `indexed_query1.png` through `indexed_query5.png` are treated as the **indexed** measurements. All ten screenshots are in `portfolio-2-query-optimisation/evidence/`.

The comparison uses the **Execution Time** printed at the bottom of each plan, rather than the node-level `actual time`, PostgreSQL estimated `cost`, or `Planning Time`. Percentage reduction is calculated as:

`((baseline execution time - indexed execution time) / baseline execution time) * 100`

The additional indexes defined in `portfolio-2-query-optimisation/indexes.sql` are:

- `idx_enrollments_offering` on `enrollments(offering_id)`
- `idx_offerings_semester` on `course_offerings(semester_id)`
- `idx_results_total_score` on `results(total_score)`
- `idx_scores_enrollment` on `assessment_scores(enrollment_id)`

PostgreSQL also has indexes created automatically for primary-key and unique constraints. Use of these existing indexes does **not** demonstrate use of one of the four additional indexes.

## 3. Measured Results

| Query | Baseline execution (ms) | Indexed execution (ms) | Observed reduction | Main plan observation |
|---|---:|---:|---:|---|
| Q1 — Student academic transcript | 0.116 | 0.097 | 16.4% | Nested loops and hash join in both; existing key indexes used; no clear use of a new index |
| Q2 — Average result per course | 1.520 | 0.185 | 87.8% | Baseline includes nested loop and `Memoize`; indexed run uses hash joins; baseline shows disk I/O, indexed run only shared-buffer hits |
| Q3 — Enrollments per department | 0.172 | 0.134 | 22.1% | Hash joins, sequential scans and hash aggregation in both; no clear use of a new index |
| Q4 — Students scoring at least 70 | 0.232 | 0.226 | 2.6% | Sequential scan of `results` in both; score index not selected |
| Q5 — Missing final results | 0.109 | 0.094 | 13.8% | Hash left join with `IS NULL` filter in both; zero rows returned |

**Interpretation:** Each indexed-labeled screenshot shows a shorter execution time than its baseline counterpart. These are observations from one captured run per condition, **not proof that the newly created indexes caused the reductions**.

## 4. Query-by-Query Analysis

### Q1 — Student Academic Transcript

The query joins `students`, `enrollments`, `course_offerings`, `courses`, `semesters` and `results`, filtering by matriculation number `STU00003`. Execution time decreased from **0.116 ms to 0.097 ms**, a **16.4% observed reduction**. Both plans use a hash join between `students` and `enrollments` and nested loops for subsequent relationships. Existing indexes such as `course_offerings_pkey` and `results_enrollment_id_key` appear in the plans. The indexed-labeled plan also uses sequential scans of the very small `courses` and `semesters` tables. Because no additional Activity 2 index is visibly used, the reduction should not be attributed directly to a newly created index.

### Q2 — Average Result per Course

The query joins `courses`, `course_offerings`, `enrollments` and `results`, aggregates average scores per course, and sorts the grouped results. Execution time decreased from **1.520 ms to 0.185 ms**, an **87.8% observed reduction**. The baseline plan uses a nested loop with a `Memoize` operation and an index lookup on `course_offerings_pkey`, followed by hash joins and aggregation. The indexed-labeled plan uses hash joins, `HashAggregate`, and a final sort. Importantly, the baseline plan reports shared-buffer **reads and dirtied buffers**, whereas the indexed-labeled plan reports shared-buffer **hits** without corresponding reads. This suggests differing cache/I/O conditions, which could account for much of the timing difference. The screenshots do not establish that a new index caused the 87.8% reduction.

### Q3 — Enrollments per Department

The query counts enrollments grouped by department and sorts the counts. Execution time decreased from **0.172 ms to 0.134 ms**, a **22.1% observed reduction**. Both plans use hash joins, sequential scans, hash aggregation, and a final quicksort. The plans do not visibly use the newly created `idx_enrollments_offering` index. The measured improvement may reflect normal execution variation, cache state, or optimizer choices rather than a direct index effect.

### Q4 — Students Scoring at Least 70

The query joins `results` with enrollments, students, offerings and courses, filters on `r.total_score >= 70`, and sorts scores in descending order. Execution time decreased from **0.232 ms to 0.226 ms**, a **2.6% observed reduction**. Both plans use a **sequential scan of `results`**, not the new `idx_results_total_score` index. The plans show **81 qualifying rows out of 120** results, with **39 removed by the filter**. Because the table is small and a large proportion of rows qualify, a sequential scan can be more economical than indexed access. This result demonstrates that creating an index does not guarantee PostgreSQL will use it or that it will materially improve a query.

### Q5 — Missing Final Results

The query searches for enrollments without a matching final result by using a left join and `r.result_id IS NULL`. Execution time decreased from **0.109 ms to 0.094 ms**, a **13.8% observed reduction**. Both plans use a hash left join and filter out **120 rows**, returning **zero missing results**. Since no rows proceed through later joins, some downstream plan nodes are marked `never executed`. The query's small runtime and unchanged main join strategy do not provide evidence that the new indexes caused the difference.

## 5. Discussion and Limitations

The screenshots demonstrate that PostgreSQL may choose sequential scans, hash joins, nested loops, and existing primary-key/unique indexes based on estimated costs and data distribution. They also illustrate why the existence of an index is different from its actual selection by the optimizer.

The following limitations apply:

1. **Single measurements:** Each condition is represented by one screenshot. Sub-millisecond timings can fluctuate between runs.
2. **Caching differences:** Query 2's baseline reports disk reads and dirtied buffers, whereas the indexed-labeled run reports shared-buffer hits. The comparison is therefore not controlled for cache state.
3. **Small tables:** The plans show about 120 enrollments/results and only a few courses and offerings. Sequential scans and hash joins can be optimal at this scale.
4. **Index attribution:** The screenshots do not clearly show use of the four new Activity 2 indexes. Some index scans use pre-existing primary-key or unique-constraint indexes.
5. **No isolated index test:** The captured runs do not establish that indexes were the only difference between conditions. There is no repeated benchmark or controlled experiment with matched cache conditions.

For stronger causal evidence, run each query several times under comparable conditions, report median execution times, record `EXPLAIN (ANALYZE, BUFFERS)` output, and check whether any of the newly added indexes are actually selected. More data and selective predicates may be needed to demonstrate benefits of the score index. Do not disable PostgreSQL scan methods in the primary benchmark merely to force index usage; forced-plan experiments should be clearly labeled separately.

## 6. Conclusion

Across the five captured comparisons, the indexed-labeled runs had execution times between **0.094 ms and 0.226 ms**, compared with **0.109 ms to 1.520 ms** for the corresponding baselines. The largest observed reduction was **87.8% for the average-result-per-course query**, but that comparison also had substantial differences in cache and I/O behavior. For the score-filter query, PostgreSQL continued to use a sequential scan despite the presence of a new index. Overall, this activity shows how to inspect execution plans and benchmark SQL queries while recognizing that observed runtime differences do not necessarily prove index effectiveness.

## 7. Evidence

All images are stored in `portfolio-2-query-optimisation/evidence/`:

- Baseline: `query1_analysis.png`, `query2_analysis.png`, `query3_analysis.png`, `query4_analysis.png`, `query5_analysis.png`
- Indexed-labeled: `indexed_query1.png`, `indexed_query2.png`, `indexed_query3.png`, `indexed_query4.png`, `indexed_query5.png`

## 8. References

- PostgreSQL Documentation, *Using EXPLAIN*: https://www.postgresql.org/docs/current/using-explain.html
- PostgreSQL Documentation, *Indexes*: https://www.postgresql.org/docs/current/indexes.html
