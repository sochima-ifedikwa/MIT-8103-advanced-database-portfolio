# Two-session concurrency experiments

Open **two separate pgAdmin Query Tool connections** (Session A and Session B), with autocommit enabled outside explicit transactions.

## Row locking (run on a disposable demonstration row)
Create `TX-LOCK` once: `INSERT INTO departments(department_code,department_name) VALUES ('TX-LOCK','Original');`

Session A:
```sql
BEGIN;
UPDATE departments SET department_name='Session A' WHERE department_code='TX-LOCK';
-- Keep transaction open.
```
Session B (execute while A is still open):
```sql
BEGIN;
SET LOCAL lock_timeout='5s';
UPDATE departments SET department_name='Session B' WHERE department_code='TX-LOCK';
-- Expected: lock timeout after about 5 seconds.
ROLLBACK;
```
Session A: `COMMIT;`. Then verify row value and delete the test row.

## Isolation: READ COMMITTED versus REPEATABLE READ
In Session A, start `BEGIN ISOLATION LEVEL READ COMMITTED;` and count rows in `departments`.
In Session B, insert a new uniquely coded test department and commit.
Back in Session A, repeat the count: the new row is visible. `COMMIT;`
Repeat using `BEGIN ISOLATION LEVEL REPEATABLE READ;` in Session A; its repeated count should remain unchanged during the transaction even after Session B commits another insert.
Use fresh test codes and remove all test rows afterward. Capture both session windows and query results.

Note: Neon connections must be separate sessions. Do not use pooled transaction connections for this demonstration.
