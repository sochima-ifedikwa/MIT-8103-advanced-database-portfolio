-- Run once after schema.sql on a clean database.
BEGIN;
INSERT INTO departments(department_code,department_name) VALUES
('CSC','Computer Science'),('MAT','Mathematics'),('BUS','Business Administration');
INSERT INTO programs(department_id,program_code,program_name,degree_level)
SELECT department_id,'BSC-CS','BSc Computer Science','Bachelor' FROM departments WHERE department_code='CSC';
INSERT INTO programs(department_id,program_code,program_name,degree_level)
SELECT department_id,'MIT','Master of Information Technology','Master' FROM departments WHERE department_code='CSC';
INSERT INTO programs(department_id,program_code,program_name,degree_level)
SELECT department_id,'BSC-MATH','BSc Mathematics','Bachelor' FROM departments WHERE department_code='MAT';
INSERT INTO lecturers(department_id,staff_number,first_name,last_name,email)
SELECT department_id,'LEC-CS-01','Ada','Nwosu','ada.nwosu@example.edu' FROM departments WHERE department_code='CSC';
INSERT INTO lecturers(department_id,staff_number,first_name,last_name,email)
SELECT department_id,'LEC-MAT-01','Tunde','Bello','tunde.bello@example.edu' FROM departments WHERE department_code='MAT';
INSERT INTO courses(department_id,course_code,course_title,credit_units,course_level)
SELECT department_id,'MIT8103','Advanced Database Systems',3,800 FROM departments WHERE department_code='CSC';
INSERT INTO courses(department_id,course_code,course_title,credit_units,course_level)
SELECT department_id,'CSC301','Database Design',3,300 FROM departments WHERE department_code='CSC';
INSERT INTO courses(department_id,course_code,course_title,credit_units,course_level)
SELECT department_id,'MAT201','Discrete Mathematics',3,200 FROM departments WHERE department_code='MAT';
INSERT INTO academic_sessions(session_name,start_date,end_date) VALUES ('2026/2027','2026-09-01','2027-08-31');
INSERT INTO semesters(session_id,semester_name,start_date,end_date)
SELECT session_id,'First','2026-09-01','2027-01-31' FROM academic_sessions WHERE session_name='2026/2027';
INSERT INTO semesters(session_id,semester_name,start_date,end_date)
SELECT session_id,'Second','2027-02-01','2027-08-15' FROM academic_sessions WHERE session_name='2026/2027';
INSERT INTO students(program_id,matric_number,first_name,last_name,email,admission_date)
SELECT p.program_id,'STU'||LPAD(g::text,5,'0'),'Student'||g,'Demo','student'||g||'@example.edu','2026-09-01'::date
FROM generate_series(1,120) g JOIN programs p ON p.program_code=CASE WHEN g%3=0 THEN 'MIT' WHEN g%3=1 THEN 'BSC-CS' ELSE 'BSC-MATH' END;
INSERT INTO course_offerings(course_id,semester_id,lecturer_id,capacity)
SELECT c.course_id,s.semester_id,l.lecturer_id,150
FROM courses c CROSS JOIN semesters s JOIN lecturers l ON l.staff_number=CASE WHEN c.course_code='MAT201' THEN 'LEC-MAT-01' ELSE 'LEC-CS-01' END
WHERE s.semester_name='First';
INSERT INTO enrollments(student_id,offering_id,registration_date)
SELECT st.student_id,co.offering_id,'2026-09-05'::date
FROM students st CROSS JOIN course_offerings co
JOIN courses c ON c.course_id=co.course_id
WHERE (c.course_code='MIT8103' AND st.student_id%3=0)
   OR (c.course_code='CSC301' AND st.student_id%3=1)
   OR (c.course_code='MAT201' AND st.student_id%3=2);
INSERT INTO assessments(offering_id,assessment_name,max_score,weight_percentage)
SELECT offering_id,'Coursework',40,40 FROM course_offerings;
INSERT INTO assessments(offering_id,assessment_name,max_score,weight_percentage)
SELECT offering_id,'Final Exam',60,60 FROM course_offerings;
INSERT INTO assessment_scores(assessment_id,enrollment_id,offering_id,score)
SELECT a.assessment_id,e.enrollment_id,e.offering_id,
 CASE WHEN a.assessment_name='Coursework' THEN (20+(e.enrollment_id%21))::numeric
 ELSE (30+(e.enrollment_id%31))::numeric END
FROM enrollments e JOIN assessments a ON a.offering_id=e.offering_id;
INSERT INTO results(enrollment_id,total_score,letter_grade,grade_point,publication_date)
SELECT x.enrollment_id,x.total_score,
 CASE WHEN x.total_score>=70 THEN 'A' WHEN x.total_score>=60 THEN 'B' WHEN x.total_score>=50 THEN 'C' WHEN x.total_score>=45 THEN 'D' WHEN x.total_score>=40 THEN 'E' ELSE 'F' END,
 CASE WHEN x.total_score>=70 THEN 5 WHEN x.total_score>=60 THEN 4 WHEN x.total_score>=50 THEN 3 WHEN x.total_score>=45 THEN 2 WHEN x.total_score>=40 THEN 1 ELSE 0 END,
 NULL
FROM (SELECT enrollment_id,SUM(score) AS total_score FROM assessment_scores GROUP BY enrollment_id) x;
COMMIT;
-- Counts and example results
SELECT 'students' AS entity,COUNT(*) FROM students UNION ALL SELECT 'enrollments',COUNT(*) FROM enrollments UNION ALL SELECT 'results',COUNT(*) FROM results;
