
-- MIT 8103: Advanced Database Systems
-- University Student Academic Management and Results Portal
-- Activity 1: Database Design and Modelling
-- Target database: university_academic_db
--
-- Run on a new/empty database.
-- Does not delete or overwrite existing tables.

BEGIN;

-- 1. Departments
CREATE TABLE departments (
    department_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    department_code VARCHAR(20) NOT NULL UNIQUE,
    department_name VARCHAR(150) NOT NULL
);

-- 2. Programs
CREATE TABLE programs (
    program_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    department_id INTEGER NOT NULL,
    program_code VARCHAR(20) NOT NULL UNIQUE,
    program_name VARCHAR(150) NOT NULL,
    degree_level VARCHAR(30) NOT NULL,

    CONSTRAINT fk_program_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id),

    CONSTRAINT chk_degree_level
        CHECK (degree_level IN (
            'Diploma', 'Bachelor', 'Master', 'PhD'
        ))
);

-- 3. Students
CREATE TABLE students (
    student_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    program_id INTEGER NOT NULL,
    matric_number VARCHAR(30) NOT NULL UNIQUE,
    first_name VARCHAR(80) NOT NULL,
    last_name VARCHAR(80) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    admission_date DATE NOT NULL,
    student_status VARCHAR(20) NOT NULL DEFAULT 'Active',

    CONSTRAINT fk_student_program
        FOREIGN KEY (program_id)
        REFERENCES programs(program_id),

    CONSTRAINT chk_student_status
        CHECK (student_status IN (
            'Active', 'Graduated', 'Suspended', 'Withdrawn'
        ))
);

-- 4. Lecturers
CREATE TABLE lecturers (
    lecturer_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    department_id INTEGER NOT NULL,
    staff_number VARCHAR(30) NOT NULL UNIQUE,
    first_name VARCHAR(80) NOT NULL,
    last_name VARCHAR(80) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,

    CONSTRAINT fk_lecturer_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

-- 5. Courses
CREATE TABLE courses (
    course_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    department_id INTEGER NOT NULL,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    course_title VARCHAR(200) NOT NULL,
    credit_units INTEGER NOT NULL,
    course_level INTEGER NOT NULL,

    CONSTRAINT fk_course_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id),

    CONSTRAINT chk_credit_units
        CHECK (credit_units BETWEEN 1 AND 10),

    CONSTRAINT chk_course_level
        CHECK (course_level BETWEEN 100 AND 999)
);

-- 6. Academic sessions
CREATE TABLE academic_sessions (
    session_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    session_name VARCHAR(20) NOT NULL UNIQUE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,

    CONSTRAINT chk_session_dates
        CHECK (end_date > start_date)
);

-- 7. Semesters
CREATE TABLE semesters (
    semester_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    session_id INTEGER NOT NULL,
    semester_name VARCHAR(30) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,

    CONSTRAINT fk_semester_session
        FOREIGN KEY (session_id)
        REFERENCES academic_sessions(session_id),

    CONSTRAINT uq_session_semester
        UNIQUE (session_id, semester_name),

    CONSTRAINT chk_semester_dates
        CHECK (end_date > start_date),

    CONSTRAINT chk_semester_name
        CHECK (semester_name IN (
            'First', 'Second', 'Summer'
        ))
);

-- 8. Course offerings
CREATE TABLE course_offerings (
    offering_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    course_id INTEGER NOT NULL,
    semester_id INTEGER NOT NULL,
    lecturer_id INTEGER NOT NULL,
    capacity INTEGER NOT NULL,

    CONSTRAINT fk_offering_course
        FOREIGN KEY (course_id)
        REFERENCES courses(course_id),

    CONSTRAINT fk_offering_semester
        FOREIGN KEY (semester_id)
        REFERENCES semesters(semester_id),

    CONSTRAINT fk_offering_lecturer
        FOREIGN KEY (lecturer_id)
        REFERENCES lecturers(lecturer_id),

    CONSTRAINT uq_course_semester_lecturer
        UNIQUE (course_id, semester_id, lecturer_id),

    CONSTRAINT chk_offering_capacity
        CHECK (capacity > 0)
);

-- 9. Enrollments
CREATE TABLE enrollments (
    enrollment_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_id INTEGER NOT NULL,
    offering_id INTEGER NOT NULL,
    registration_date DATE NOT NULL DEFAULT CURRENT_DATE,
    enrollment_status VARCHAR(20) NOT NULL DEFAULT 'Registered',

    CONSTRAINT fk_enrollment_student
        FOREIGN KEY (student_id)
        REFERENCES students(student_id),

    CONSTRAINT fk_enrollment_offering
        FOREIGN KEY (offering_id)
        REFERENCES course_offerings(offering_id),

    CONSTRAINT uq_student_offering
        UNIQUE (student_id, offering_id),

    CONSTRAINT chk_enrollment_status
        CHECK (enrollment_status IN (
            'Registered', 'Completed', 'Dropped'
        )),

    -- Supports composite foreign keys for score validation
    CONSTRAINT uq_enrollment_offering_pair
        UNIQUE (enrollment_id, offering_id)
);

-- 10. Assessments
CREATE TABLE assessments (
    assessment_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    offering_id INTEGER NOT NULL,
    assessment_name VARCHAR(100) NOT NULL,
    max_score NUMERIC(7,2) NOT NULL,
    weight_percentage NUMERIC(5,2) NOT NULL,

    CONSTRAINT fk_assessment_offering
        FOREIGN KEY (offering_id)
        REFERENCES course_offerings(offering_id),

    CONSTRAINT uq_offering_assessment_name
        UNIQUE (offering_id, assessment_name),

    CONSTRAINT chk_max_score
        CHECK (max_score > 0),

    CONSTRAINT chk_assessment_weight
        CHECK (
            weight_percentage > 0
            AND weight_percentage <= 100
        ),

    -- Supports composite foreign keys for score validation
    CONSTRAINT uq_assessment_offering_pair
        UNIQUE (assessment_id, offering_id)
);

-- 11. Assessment scores
CREATE TABLE assessment_scores (
    score_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    assessment_id INTEGER NOT NULL,
    enrollment_id INTEGER NOT NULL,
    score NUMERIC(7,2) NOT NULL,
    offering_id INTEGER NOT NULL,

    CONSTRAINT fk_score_assessment_offering
        FOREIGN KEY (assessment_id, offering_id)
        REFERENCES assessments(assessment_id, offering_id),

    CONSTRAINT fk_score_enrollment_offering
        FOREIGN KEY (enrollment_id, offering_id)
        REFERENCES enrollments(enrollment_id, offering_id),

    CONSTRAINT uq_assessment_enrollment
        UNIQUE (assessment_id, enrollment_id),

    CONSTRAINT chk_score_nonnegative
        CHECK (score >= 0)
);

-- 12. Final results
CREATE TABLE results (
    result_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    enrollment_id INTEGER NOT NULL UNIQUE,
    total_score NUMERIC(7,2) NOT NULL,
    letter_grade VARCHAR(2) NOT NULL,
    grade_point NUMERIC(3,2) NOT NULL,
    publication_date DATE,

    CONSTRAINT fk_result_enrollment
        FOREIGN KEY (enrollment_id)
        REFERENCES enrollments(enrollment_id),

    CONSTRAINT chk_total_score
        CHECK (total_score BETWEEN 0 AND 100),

    CONSTRAINT chk_letter_grade
        CHECK (letter_grade IN ('A', 'B', 'C', 'D', 'E', 'F')),

    CONSTRAINT chk_grade_point
        CHECK (grade_point BETWEEN 0 AND 5)
);

COMMIT;
