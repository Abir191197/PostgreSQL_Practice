-- Create database
CREATE DATABASE university_db;


-- Create students table
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    age INTEGER NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    frontend_mark INTEGER,
    backend_mark INTEGER,
    status VARCHAR(20)
);

-- Create courses table
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    credits INTEGER NOT NULL
);

-- Create enrollment table
CREATE TABLE enrollment (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(student_id),
    course_id INTEGER REFERENCES courses(course_id)
);

-- Insert sample data into students table
INSERT INTO students (student_name, age, email, frontend_mark, backend_mark, status) VALUES
('Sameer', 21, 'sameer@example.com', 48, 60, NULL),
('Zoya', 23, 'zoya@example.com', 52, 58, NULL),
('Nabil', 22, 'nabil@example.com', 37, 46, NULL),
('Rafi', 24, 'rafi@example.com', 41, 40, NULL),
('Sophia', 22, 'sophia@example.com', 50, 52, NULL),
('Hasan', 23, 'hasan@gmail.com', 43, 39, NULL);

-- Insert sample data into courses table
INSERT INTO courses (course_name, credits) VALUES
('Next.js', 3),
('React.js', 4),
('Databases', 3),
('Prisma', 3);

-- Insert sample data into enrollment table
INSERT INTO enrollment (student_id, course_id) VALUES
(1, 1),
(1, 2),
(2, 1),
(3, 2);

-- Query 1: Insert a new student
INSERT INTO students (student_name, age, email, frontend_mark, backend_mark, status)
VALUES ('abir', 25, 'abir@gmail.com', 55, 58, NULL);

-- Query 2: Retrieve students enrolled in Next.js
SELECT DISTINCT s.student_name
FROM students s
JOIN enrollment e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Next.js';

-- Query 3: Update status of student with highest total marks
WITH total_marks AS (
    SELECT student_id, (frontend_mark + backend_mark) as total
    FROM students
    WHERE frontend_mark IS NOT NULL AND backend_mark IS NOT NULL
)
UPDATE students
SET status = 'Awarded'
WHERE student_id = (
    SELECT student_id
    FROM total_marks
    WHERE total = (SELECT MAX(total) FROM total_marks)
);

-- Query 4: Delete courses with no enrollments
DELETE FROM courses
WHERE course_id NOT IN (
    SELECT DISTINCT course_id
    FROM enrollment
);

-- Query 5: Retrieve students with LIMIT and OFFSET
SELECT student_name
FROM students
ORDER BY student_id
LIMIT 2 OFFSET 2;

-- Query 6: Count students enrolled in each course
SELECT c.course_name, COUNT(e.student_id) as students_enrolled
FROM courses c
LEFT JOIN enrollment e ON c.course_id = e.course_id
GROUP BY c.course_name;

-- Query 7: Calculate average age
SELECT ROUND(AVG(age)::numeric, 2) as average_age
FROM students;

-- Query 8: Find students with example.com email
SELECT student_name
FROM students
WHERE email LIKE '%example.com';