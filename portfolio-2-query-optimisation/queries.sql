-- Query 1: Student academic transcript
SELECT s.matric_number,s.first_name,s.last_name,c.course_code,c.course_title,
       se.semester_name,r.total_score,r.letter_grade,r.grade_point
FROM students s JOIN enrollments e ON e.student_id=s.student_id
JOIN course_offerings co ON co.offering_id=e.offering_id
JOIN courses c ON c.course_id=co.course_id
JOIN semesters se ON se.semester_id=co.semester_id
LEFT JOIN results r ON r.enrollment_id=e.enrollment_id
WHERE s.matric_number='STU00003';

-- Query 2: Average result per course
SELECT c.course_code,COUNT(r.result_id) AS graded_students,ROUND(AVG(r.total_score),2) AS average_score
FROM courses c JOIN course_offerings co ON co.course_id=c.course_id
JOIN enrollments e ON e.offering_id=co.offering_id
JOIN results r ON r.enrollment_id=e.enrollment_id
GROUP BY c.course_code ORDER BY average_score DESC;

-- Query 3: Enrollment per department
SELECT d.department_name,COUNT(e.enrollment_id) AS enrollments
FROM departments d JOIN courses c ON c.department_id=d.department_id
JOIN course_offerings co ON co.course_id=c.course_id
LEFT JOIN enrollments e ON e.offering_id=co.offering_id
GROUP BY d.department_name ORDER BY enrollments DESC;

-- Query 4: Students scoring at least 70
SELECT s.matric_number,c.course_code,r.total_score
FROM results r JOIN enrollments e ON e.enrollment_id=r.enrollment_id
JOIN students s ON s.student_id=e.student_id
JOIN course_offerings co ON co.offering_id=e.offering_id
JOIN courses c ON c.course_id=co.course_id
WHERE r.total_score>=70 ORDER BY r.total_score DESC;

-- Query 5: Missing final results
SELECT s.matric_number,c.course_code
FROM enrollments e JOIN students s ON s.student_id=e.student_id
JOIN course_offerings co ON co.offering_id=e.offering_id
JOIN courses c ON c.course_id=co.course_id
LEFT JOIN results r ON r.enrollment_id=e.enrollment_id
WHERE r.result_id IS NULL;
