# Activity 4 — NoSQL and Advanced Data Models

**Course:** MIT 8103 – Advanced Database Systems  
**Project:** University Student Academic Management and Results Portal

## 1. Objective

The objective of this activity is to demonstrate document-oriented database modelling and operations using MongoDB.

## 2. Implementation Environment

- Database platform: MongoDB Atlas
- Database name: `mit8103_academic_nosql`
- Collection: `student_profiles`
- Data model: Document-oriented (BSON)

## 3. Document Model

The `student_profiles` collection stores student information alongside nested preferences and arrays of interests and skills.

This structure demonstrates MongoDB's support for embedded documents, arrays and flexible schemas.

## 4. Database Operations

The implementation exercises include:

1. Inserting student-profile documents.
2. Retrieving all student documents.
3. Filtering by programme.
4. Querying nested preference fields.
5. Searching array values.
6. Updating nested fields.
7. Creating a unique index on `matric_number`.
8. Aggregating student counts by programme.

## 5. Comparison with PostgreSQL

PostgreSQL uses relational tables, foreign keys and SQL joins to manage structured academic records.

MongoDB stores related profile information within documents, which is useful for preferences, interests and other flexible student attributes.

PostgreSQL remains the primary database for enrollment and academic results, while MongoDB demonstrates an alternative data model for student profiles.

## 6. Evidence
The screenshots for all of these files are in the evidence folder
- `student-documents.png`
- `find-computer-science.png`
- `nested-query.png`
- `document-update.png`
- `unique-index.png`
- `aggregation-results.png`

## 7. Conclusion

The activity demonstrates the use of MongoDB for document storage, filtering, updates, indexing and aggregation. It also highlights differences between document-oriented and relational database models.