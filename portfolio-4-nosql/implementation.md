# MongoDB Document Model

Use MongoDB Atlas or local MongoDB and mongosh. Run `mongodb-demo.js` once in a fresh demonstration database.

## Model choice
Store flexible student profiles and preferences as JSON-like BSON documents, with nested `name` and `preferences` objects and a `skills` array. Keep authoritative enrollment, assessments, grades and referentially constrained records in PostgreSQL.

## Evidence
Capture collection creation, sample documents, a filter query, update, index, and aggregation results.

## Comparison
PostgreSQL uses a fixed relational schema and foreign keys. MongoDB permits flexible nested documents; it is convenient for variable profile attributes but cross-document consistency and relationships require deliberate design.
