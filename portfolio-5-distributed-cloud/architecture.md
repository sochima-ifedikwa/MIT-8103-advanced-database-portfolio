# Distributed and Cloud Database Exercise

## Actual deployment
Neon-managed PostgreSQL hosts `university_academic_db`; pgAdmin on Windows accesses it over an encrypted connection. GitHub stores schema, scripts and documentation. Vercel is a *planned* application host, not an active deployment unless separately completed.

## Concepts and evidence
- **Compute/storage separation:** Explain Neon's architecture using current official Neon documentation and cite it.
- **Branching:** If available, create a disposable Neon branch, confirm its data snapshot, and capture evidence. Delete it after the experiment.
- **Replication / availability:** Research Neon provider features and document which are actually enabled in your plan. Do not claim you configured replicas without proof.
- **Sharding:** Explain partitioning/sharding conceptually; this project does not implement distributed sharding.
- **Consistency:** Discuss PostgreSQL ACID transactions and MVCC. Distinguish single-primary transaction behavior from distributed replicas.
- **Security:** TLS, least-privilege roles, environment variables and credential rotation.
- **Trade-offs:** Cloud network latency, free-tier resource limits, provider dependence, and backup/recovery limitations.

## Evidence checklist
Screenshots: Neon project overview (redact credentials), database list, branch overview, pgAdmin SSL connection configuration (no password), and successful SQL query. Add screenshots of only those features you actually tested.
