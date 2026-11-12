# Database Normalization Documentation

**Course:** MIT 8103 – Advanced Database Systems  
**Project:** University Student Academic Management and Results Portal  
**Database:** `university_academic_db`

## 1. Introduction

Database normalization is the process of organizing relational data to reduce unnecessary duplication and prevent insertion, update and deletion anomalies.

The University Student Academic Management and Results Portal was designed using the principles of First Normal Form (1NF), Second Normal Form (2NF) and Third Normal Form (3NF).

The objective is to store information about students, departments, programmes, courses, registrations, assessments and results in logically related tables while maintaining referential integrity.

## 2. Unnormalized Form (UNF)

Consider an initial student academic record that combines student information, programme information and multiple registered courses in one record.

| Matric Number | Student Name | Programme | Registered Courses |
|---|---|---|---|
| STU001 | Ada Okafor | Computer Science | CSC101 (85), MAT101 (72) |
| STU002 | David Bello | Information Technology | CSC101 (68), GST101 (80) |

This hypothetical unnormalized structure contains repeating groups because one student record can include multiple courses and their scores.

Problems include:

- Difficulty searching or updating individual course registrations.
- Repetition of student and programme details.
- Difficulty adding a new course before a student registers for it.
- Risk of losing course information when the last registration is deleted.

## 3. First Normal Form (1NF)

A relation satisfies 1NF when each attribute contains an atomic value and repeating groups are removed.

The registered courses can be separated into individual rows.

| Matric Number | Student Name | Programme | Course Code | Score |
|---|---|---|---|---:|
| STU001 | Ada Okafor | Computer Science | CSC101 | 85 |
| STU001 | Ada Okafor | Computer Science | MAT101 | 72 |
| STU002 | David Bello | Information Technology | CSC101 | 68 |
| STU002 | David Bello | Information Technology | GST101 | 80 |

Each row now represents one student's registration in one course, and each cell contains a single value.

However, student names and programme information are still repeated across multiple rows.

The table is in 1NF but still has redundancy.

## 4. Second Normal Form (2NF)

A relation satisfies 2NF when it is in 1NF and every non-prime attribute depends on the whole of every candidate key, rather than only part of a composite candidate key.

In the illustrative registration table, assume `(matric_number, course_code)` uniquely identifies a registration for one academic offering period.

The following dependencies exist:

- `matric_number → student_name, programme`
- `course_code → course_title` (if course title is included)
- `(matric_number, course_code) → score`

Student details depend only on the matriculation number, not on the complete composite key.

Course details depend only on the course code.

To remove these partial dependencies, the information is separated into distinct relations.

**STUDENTS**

`students(student_id PK, program_id FK, matric_number, first_name, last_name, email, admission_date, student_status)`

**COURSES**

`courses(course_id PK, department_id FK, course_code, course_title, credit_units, course_level)`

**ENROLLMENTS**

`enrollments(enrollment_id PK, student_id FK, offering_id FK, registration_date, enrollment_status)`

The implemented schema uses `course_offerings` to distinguish instances of courses offered in different semesters.

The enrollment relation uses a surrogate primary key and a unique constraint on `(student_id, offering_id)`.

Student attributes are stored in `students`, course attributes are stored in `courses`, and registration-specific attributes are stored in `enrollments`.

This separation removes the partial dependencies illustrated in the original combined table.

## 5. Third Normal Form (3NF)

A relation satisfies 3NF when it is in 2NF and, for every nontrivial functional dependency `X → A`, either `X` is a superkey or `A` is a prime attribute.

A common source of 3NF violations is storing descriptive information that depends on another non-key attribute.

For example, consider:

`students(student_id, matric_number, student_name, program_id, program_name, department_name)`

Possible dependencies include:

- `student_id → program_id`
- `program_id → program_name`
- `program_id → department_id`
- `department_id → department_name`

Storing programme and department names in the student relation creates transitive dependencies.

The implemented database separates this information into:

**DEPARTMENTS**

`departments(department_id PK, department_code, department_name)`

**PROGRAMS**

`programs(program_id PK, department_id FK, program_code, program_name, degree_level)`

**STUDENTS**

`students(student_id PK, program_id FK, matric_number, first_name, last_name, email, admission_date, student_status)`

Programme information is maintained in `programs`, while department information is maintained in `departments`.

The `students` relation references the programme using `program_id` rather than duplicating programme and department names.

This removes the transitive dependencies in the illustrative combined student table.

## 6. Normalization of Other Relations

The same design principles were applied to the remaining entities.

| Relation | Normalization rationale |
|---|---|
| `lecturers` | Stores lecturer-specific attributes and references the department instead of repeating department details. |
| `academic_sessions` | Stores academic-session information independently of semesters. |
| `semesters` | References its academic session instead of repeating session attributes. |
| `course_offerings` | Separates the course definition from its delivery in a specific semester by a lecturer. |
| `assessments` | Stores assessment definitions separately from individual student scores. |
| `assessment_scores` | Stores scores associated with specific enrollments and assessments. |
| `results` | Stores one final academic result per enrollment, without duplicating student or course descriptive information. |

These decompositions support the normalization goals of the system.

## 7. Controlled Redundancy and Design Trade-offs

Although the database is organized around 3NF principles, two design decisions require additional consideration.

### 7.1 Assessment scores

The `assessment_scores` relation includes `offering_id` alongside `assessment_id` and `enrollment_id`.

Because each assessment and enrollment already identifies a course offering, `offering_id` can be derived through their referenced relations.

Its inclusion provides a practical way to enforce, using composite foreign keys, that a student's enrollment and the assessment belong to the same offering.

However, the unique constraint on `(assessment_id, enrollment_id)` also creates a candidate key, and the dependency from `assessment_id` to `offering_id` means this relation is not strictly in 3NF under the usual functional-dependency assumptions.

This is intentional controlled redundancy for stronger declarative referential integrity. An alternative design would omit `offering_id` and enforce offering consistency using a database trigger or controlled application logic.

### 7.2 Final results

The `results` relation stores `total_score`, `letter_grade` and `grade_point`.

These values are related by the university's grading policy. In a completed system, letter grades and grade points may be calculated from total scores, making some of these stored attributes derivable.

Storing them can improve reporting performance and preserve published academic results, but it introduces a risk of inconsistency if the grading policy is not enforced.

A future improvement is to maintain a grading-policy table and calculate or validate the final grade through controlled database procedures.

## 8. Benefits of the Normalized Design

The database design provides the following benefits:

- **Reduced duplication:** Student, programme, department and course details are stored in their respective relations.
- **Improved update consistency:** Changes to a department name do not require updates to every student record.
- **Reduced insertion anomalies:** New courses and programmes can be recorded before students register for them.
- **Reduced deletion anomalies:** Removing an enrollment does not delete the corresponding student or course definition.
- **Referential integrity:** Foreign keys prevent references to nonexistent parent records.
- **Maintainability:** Each relation has a clearly defined purpose and can be extended independently.

## 9. Conclusion

The University Student Academic Management and Results Portal uses normalization principles to separate university information into 12 related tables.

The main student, programme, department, course and enrollment relations address the partial and transitive dependencies illustrated in the normalization process.

The design also contains deliberate redundancy in assessment-score validation and potentially derived final-result attributes. These trade-offs are documented so that the schema can be evaluated accurately and refined as the system develops.

Overall, the design provides a suitable relational foundation for the subsequent query optimization, transaction processing and cloud database activities.