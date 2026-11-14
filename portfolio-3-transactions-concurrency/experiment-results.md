# Activity 3: Transaction Management and Concurrency Control

**Course:** MIT 8103 – Advanced Database Systems  
**Project:** University Student Academic Management and Results Portal

## 1. Objective

To investigate PostgreSQL transaction management, ACID properties, row-level locking, and transaction isolation using a cloud-hosted academic database.

## 2. Environment

- DBMS: PostgreSQL
- Cloud platform: Neon
- Database: `university_academic_db`
- Client: pgAdmin 4
- Test environment: `activity5-development` branch

## 3. Transaction Experiments

| Experiment | Expected outcome | Observed outcome |
|---|---|---|
| COMMIT | Inserted row persists | `Transaction Demo` |
| ROLLBACK | Uncommitted insert disappears | `Duplicate key value violates unique constraint  "departments_department_code_key" Detail:Key(department_code)=(TX Toll) alreay exists.` |
| SAVEPOINT | First insert persists; second is undone | `TX-SAVE Savepoint Demo` |

The experiments illustrate PostgreSQL's ability to commit, undo, and partially roll back transactional changes.

## 4. Concurrent Update and Locking

Two independent PostgreSQL sessions attempted to update the same department record.

Session A updated the record while retaining an open transaction. Session B attempted a conflicting update with a five-second lock timeout.

**Observed outcome:** [Session A shows `TX-LOCk Session A `, while Session B returns `canceling statement due to lock timeout CONTEXT: while updating tuple(0, 16) in relation "departments"`]

This experiment illustrates how PostgreSQL coordinates conflicting concurrent updates through row-level locks.

## 5. Transaction Isolation

### READ COMMITTED

- First department count: [5]
- Count after Session B committed: [N + 1]
- Observation: [5]

### REPEATABLE READ

- First department count: [5]
- Count after Session B committed: [5]
- Count after Session A committed: [N + 1]
- Observation: The count increased by one and became 6

These experiments compare statement-level snapshots with a transaction-level snapshot.

## 6. Discussion

Transaction management is important for the academic management portal because operations such as student enrollment, assessment recording, and result publication require reliable data changes.

COMMIT and ROLLBACK support atomicity. Row-level locking coordinates concurrent updates, while transaction isolation controls the visibility of changes made by other sessions.

## 7. Limitations

The experiments used demonstration records rather than production academic data.

They did not benchmark high-volume concurrency, simulate infrastructure failures, or evaluate every PostgreSQL isolation level.

## 8. Conclusion

[Summarize the actual findings after completing the experiments.]

## 9. Evidence

Screenshots are available in the `evidence/` directory.

## 10. References

- PostgreSQL Documentation: Transactions — https://www.postgresql.org/docs/current/tutorial-transactions.html
- PostgreSQL Documentation: Transaction Isolation — https://www.postgresql.org/docs/current/transaction-iso.html
- PostgreSQL Documentation: Explicit Locking — https://www.postgresql.org/docs/current/explicit-locking.html
