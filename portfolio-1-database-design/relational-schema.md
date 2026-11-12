# Relational Schema Documentation

**Course:** MIT 8103 – Advanced Database Systems  
**Project:** University Student Academic Management and Results Portal  
**Student:** Sochima Ifedikwa  
**Student ID:** 301900654  
**Database:** `university_academic_db`  
**Database Management System:** PostgreSQL (Neon Cloud)

## 1. Introduction

The University Student Academic Management and Results Portal is designed to manage university departments, degree programmes, students, lecturers, courses, academic sessions, semesters, course registrations, assessments and academic results.

The database uses the relational model, with primary keys identifying individual records and foreign keys establishing relationships between entities. The schema is implemented using PostgreSQL and hosted on Neon.

## 2. Relational Schema

The database consists of 12 relations. The notation PK indicates a primary key, FK indicates a foreign key, and UK indicates a unique key.

**1. DEPARTMENTS**

`departments(department_id PK, department_code UK, department_name)`

Stores university departments. Department codes must be unique.

**2. PROGRAMS**

`programs(program_id PK, department_id FK, program_code UK, program_name, degree_level)`

References `departments(department_id)`. Each programme belongs to one department.

**3. STUDENTS**

`students(student_id PK, program_id FK, matric_number UK, first_name, last_name, email UK, admission_date, student_status)`

References `programs(program_id)`. Each student belongs to one programme. Matriculation numbers and email addresses are unique.

**4. LECTURERS**

`lecturers(lecturer_id PK, department_id FK, staff_number UK, first_name, last_name, email UK)`

References `departments(department_id)`. Each lecturer belongs to one department.

**5. COURSES**

`courses(course_id PK, department_id FK, course_code UK, course_title, credit_units, course_level)`

References `departments(department_id)`. Credit units are restricted to 1–10, while course levels are restricted to 100–999.

**6. ACADEMIC_SESSIONS**

`academic_sessions(session_id PK, session_name UK, start_date, end_date)`

Stores academic sessions. The end date must be later than the start date.

**7. SEMESTERS**

`semesters(semester_id PK, session_id FK, semester_name, start_date, end_date)`

References `academic_sessions(session_id)`. The combination `(session_id, semester_name)` must be unique.

**8. COURSE_OFFERINGS**

`course_offerings(offering_id PK, course_id FK, semester_id FK, lecturer_id FK, capacity)`

References `courses`, `semesters` and `lecturers`. The combination `(course_id, semester_id, lecturer_id)` must be unique. Capacity must be greater than zero.

**9. ENROLLMENTS**

`enrollments(enrollment_id PK, student_id FK, offering_id FK, registration_date, enrollment_status)`

References `students` and `course_offerings`. The combination `(student_id, offering_id)` is unique to prevent duplicate enrollment in the same offering.

The additional unique constraint `(enrollment_id, offering_id)` supports composite referential integrity for assessment scores.

**10. ASSESSMENTS**

`assessments(assessment_id PK, offering_id FK, assessment_name, max_score, weight_percentage)`

References `course_offerings(offering_id)`. Assessment names are unique within each offering. Maximum scores must be positive, and assessment weights must be greater than zero and at most 100%.

The additional unique constraint `(assessment_id, offering_id)` supports composite referential integrity.

**11. ASSESSMENT_SCORES**

`assessment_scores(score_id PK, assessment_id FK, enrollment_id FK, offering_id FK, score)`

Contains two composite foreign keys:

- `(assessment_id, offering_id)` references `assessments(assessment_id, offering_id)`.
- `(enrollment_id, offering_id)` references `enrollments(enrollment_id, offering_id)`.

These constraints ensure that an assessment score is associated with an enrollment and assessment belonging to the same course offering.

The combination `(assessment_id, enrollment_id)` must be unique. Scores must be nonnegative.

**12. RESULTS**

`results(result_id PK, enrollment_id FK/UK, total_score, letter_grade, grade_point, publication_date)`

References `enrollments(enrollment_id)`. The unique constraint on `enrollment_id` permits at most one final result per enrollment.

Total scores must fall between 0 and 100, letter grades must be A–F, and grade points must fall between 0 and 5.

## 3. Relationships and Cardinality

| Parent relation | Child relation | Cardinality |
|---|---|---|
| Departments | Programs | One-to-many |
| Departments | Lecturers | One-to-many |
| Departments | Courses | One-to-many |
| Programs | Students | One-to-many |
| Academic Sessions | Semesters | One-to-many |
| Courses | Course Offerings | One-to-many |
| Semesters | Course Offerings | One-to-many |
| Lecturers | Course Offerings | One-to-many |
| Students | Enrollments | One-to-many |
| Course Offerings | Enrollments | One-to-many |
| Course Offerings | Assessments | One-to-many |
| Enrollments | Assessment Scores | One-to-many |
| Assessments | Assessment Scores | One-to-many |
| Enrollments | Results | One-to-zero-or-one |

The many-to-many relationship between students and course offerings is resolved through the `enrollments` relation.

## 4. Integrity Constraints

The PostgreSQL schema implements the following integrity mechanisms:

- **Entity integrity:** Each table has a primary key.
- **Referential integrity:** Foreign keys reference valid parent records.
- **Uniqueness:** Unique constraints protect department codes, programme codes, student identifiers, course codes and selected composite keys.
- **Domain integrity:** `CHECK` constraints restrict values such as credit units, scores, grades, capacities and statuses.
- **Mandatory attributes:** `NOT NULL` constraints ensure required values are supplied.

## 5. Additional Business Rules

The initial schema does not yet enforce every university business rule. The following require further implementation:

- Preventing enrollment beyond course capacity.
- Ensuring assessment scores do not exceed the assessment maximum.
- Ensuring assessment weights total 100% before results are finalized.
- Ensuring semester dates fall within the academic session.
- Validating final grades against the university's grading policy.

These rules will be addressed through database validation, triggers and transaction logic in subsequent practical activities.

## 6. Implementation Environment

The database was implemented in PostgreSQL using the Neon cloud platform. pgAdmin 4 was used to connect to the database, execute SQL statements and inspect database objects.

The SQL implementation is maintained in `database/schema.sql`, while the editable entity-relationship diagram and exported image are maintained in `portfolio-1-database-design/`.

## 7. Conclusion

The relational schema establishes a structured foundation for managing student academic records. The use of primary keys, foreign keys, uniqueness constraints and domain validation helps maintain data consistency and supports subsequent work on query optimization, transactions and distributed database deployment.