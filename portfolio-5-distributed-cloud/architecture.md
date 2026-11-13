# Activity 5: Distributed and Cloud Database Exercise

**Course:** MIT 8103 – Advanced Database Systems  
**Project:** University Student Academic Management and Results Portal  
**Student:** Sochima Ifedikwa  
**Student ID:** 301900654

## 1. Introduction

This activity explores cloud database deployment, distributed database architecture, database branching, and transaction consistency using Neon PostgreSQL.

The University Student Academic Management and Results Portal database was deployed on Neon, a cloud-hosted PostgreSQL platform.

## 2. Cloud Database Environment

The following environment was used:

- **Cloud database platform:** Neon PostgreSQL
- **Project:** `mit-8103-university-db`
- **Database:** `university_academic_db`
- **Development branch:** `activity5-development`
- **PostgreSQL version:** [18]
- **Cloud region:** [AWS US East 1 (N. Virginia)]
- **Primary branch:** [main]

The database supports academic records such as students, programmes, courses, enrollments, assessments, and results.

## 3. Cloud Database Architecture

Neon separates PostgreSQL compute from storage.

The compute layer processes SQL queries and transactions, while the storage architecture manages database pages and write-ahead log data.

This separation supports independent compute management and database branching.

The experiment used Neon's managed infrastructure rather than a manually configured distributed PostgreSQL cluster.

## 4. Database Branching Experiment

A development branch named `activity5-development` was created from the primary database branch.

A table named `activity5_branch_test` was created on the development branch, and a demonstration record was inserted.

The primary branch was then checked to determine whether the test table existed.

**Observed result:** [Insert actual query output]

This experiment illustrates how independent database branches can be used for development and testing without directly modifying the original branch.

## 5. Transaction Consistency

Two PostgreSQL transaction experiments were performed.

### Experiment A: ROLLBACK

A transaction created a test table and inserted a record. The transaction was then rolled back.

**Observed result:** [Insert actual result]

### Experiment B: COMMIT

A separate transaction created a table and inserted a record before committing.

**Observed result:** [Insert actual result]

The experiments demonstrate the difference between committed and rolled-back database changes.

## 6. Distributed Database Concepts

### Replication

Replication maintains copies of data across storage components or database instances to improve resilience and availability.

Neon's managed storage architecture incorporates mechanisms for durable and replicated database storage. The underlying replication infrastructure was not manually configured in this exercise.

### Sharding

Sharding distributes data across multiple database partitions or servers.

For a larger university information system, a potential sharding strategy would distribute academic records by institution or campus.

No application-level sharding was implemented during this exercise.

### Availability

Cloud database availability depends on infrastructure redundancy, recovery mechanisms, service configuration, and provider capabilities.

Neon's managed architecture provides mechanisms that support database durability and recovery, although the exercise did not include a controlled infrastructure failure test.

### Consistency

PostgreSQL supports ACID transactions.

The COMMIT and ROLLBACK experiments illustrate atomic transaction behavior within the cloud-hosted database.

## 7. Challenges and Limitations

The exercise was conducted using a managed cloud database environment.

The scope was limited to database deployment, branching, and transaction testing. Manual replication configuration, application-level sharding, and infrastructure failure testing were not performed.

## 8. Conclusion

This activity provided practical experience with a cloud-hosted PostgreSQL database, database branching, and transaction consistency.

It also developed an understanding of distributed database concepts such as replication, sharding, availability, and consistency.

## 9. Evidence

- Cloud database configuration screenshot
- Development branch screenshot
- Branch isolation test screenshot
- Transaction rollback screenshot
- Transaction commit screenshot

## 10. References

- Neon Documentation: https://neon.com/docs
- PostgreSQL Documentation: https://www.postgresql.org/docs/current/
