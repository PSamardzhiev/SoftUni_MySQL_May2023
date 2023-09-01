# create database unis;
# use unis;
# drop database unis;

create table countries
(
    id   int primary key auto_increment,
    name VARCHAR(40) NOT NULL UNIQUE

);
create table cities
(
    id         int primary key auto_increment,
    name       varchar(40) not null unique,
    population INT,
    country_id INT         NOT NULL,

    constraint fk_cities_countries
        FOREIGN KEY (country_id)
            references countries (id)
);
create table universities
(
    id              int primary key auto_increment,
    name            VARCHAR(60)    not null unique,
    address         VARCHAR(80)    not null unique,
    tuition_fee     DECIMAL(19, 2) not null,
    number_of_staff INT,
    city_id         INT,

    CONSTRAINT fk_universities_cities
        FOREIGN KEY (city_id)
            REFERENCES cities (id)
);
create table students
(
    id           int primary key auto_increment,
    first_name   VARCHAR(40)  NOT NULL,
    last_name    VARCHAR(40)  NOT NULL,
    age          INT,
    phone        VARCHAR(20)  NOT NULL UNIQUE,
    email        VARCHAR(255) NOT NULL UNIQUE,
    is_graduated TINYINT(1)   NOT NULL,
    city_id      INT,

    CONSTRAINT fk_students_cities
        FOREIGN KEY (city_id)
            REFERENCES cities (id)

);
create table courses
(
    id             int primary key auto_increment,
    name           VARCHAR(40) NOT NULL UNIQUE,
    duration_hours DECIMAL(19, 2),
    start_date     DATE,
    teacher_name   VARCHAR(60) NOT NULL UNIQUE,
    description    TEXT,
    university_id  INT,

    constraint fk_courses_universities
        FOREIGN KEY (university_id)
            REFERENCES universities (id)
);
create table students_courses
(
    grade      DECIMAL(19, 2) NOT NULL,
    student_id INT            NOT NULL,
    course_id  INT            NOT NULL,

    CONSTRAINT fk_sc_students
        FOREIGN KEY (student_id)
            REFERENCES students (id),

    CONSTRAINT fk_sc_courses
        FOREIGN KEY (course_id)
            REFERENCES courses (id)
);

-- 2
# You will have to insert records of data into the courses table, based on the courses table.
#     For courses with id equal or lesser than 5, insert data in the course table with the following values:
#     •	name – set it to the teacher name followed by white space and then "course"
# (teacher_name + " " + "course")
# •	duration_hours – set it to the total number of characters from the course name and the result devided by 10.
# •	start_date – set it to the start date of the course but 5 days later.
# •	teacher_name – set it to the teacher name but reversed.
# •	description – set it to "Course " followed by the teacher name and the description but reversed.
#  ("Course " + teacher_name + description_reversed)
# •	university¬_id – set it to the day of the start date of the original course.

SELECT * FROM courses;

INSERT INTO courses (name,duration_hours,start_date,teacher_name,description,university_id)
SELECT
        concat(teacher_name, ' ', 'course'),
        length(name) / 10,
        date_add(start_date, interval 5 DAY),
        REVERSE(teacher_name),
        CONCAT('Course',' ', teacher_name, REVERSE(description)),
        day(start_date)
FROM courses
WHERE id <= 5;


-- 3

# Due to inflation and the rising cost of living some universities must raise their tuition fees.
# Raise the tuition fee by 300 for all universities with id equal or greater than 5 and less than 12 (inclusive).

select * from universities;

UPDATE universities as u
set u.tuition_fee = u.tuition_fee + 300
WHERE id between 5 and 12;

-- 4

#     There are some minor bugs in the system and some universities didn’t send the correct information.
#     Delete all universities for which we don’t have information about the number of staff.

DELETE from universities
WHERE number_of_staff is null;


-- 5

select id,
       name,
       population,
       country_id

from cities
ORDER BY population DESC;

-- 6
select first_name,
       last_name,
       age,
       phone,
       email

FROM students
WHERE age >= 21
ORDER BY first_name DESC, email ASC, id asc
LIMIT 10;

-- 7

select
    CONCAT_WS(' ', first_name,last_name) as full_name,
    SUBSTRING(email,2,10) as username,
    REVERSE(phone) as password
from students as s
left join students_courses sc on s.id = sc.student_id
WHERE course_id is NULL
ORDER BY password desc;

-- 8

# Every university has courses with students.
# The directors of every university want to know the total number of students assigned to courses. Extract from the database
# the students_count (total number of assigned students) in each university and the corresponding university_name. Get only those universities with students_count equal or greater than 8.
# Order the results descending by students_count and then by university_name in descending order.
#  Required Columns
# •	students_count
# •	university_name

SELECT COUNT(*) AS students_count, u.name AS university_name
FROM universities AS u
         JOIN courses AS c ON u.id = c.university_id
JOIN students_courses AS sc ON c.id = sc.course_id
GROUP BY u.id, u.name
HAVING students_count >= 8
ORDER BY students_count DESC, university_name DESC;

-- 9
select * from universities, cities;

SELECT
    u.name as university_name,
       c.name as city_name,
       u.address as address,
       CASE
           WHEN u.tuition_fee < 800 THEN 'cheap'
           WHEN u.tuition_fee >= 800 AND u.tuition_fee < 1200 THEN 'normal'
           WHEN u.tuition_fee >= 1200 AND u.tuition_fee < 2500 THEN 'high'
           ELSE 'expensive'
           END AS price_rank,
    u.tuition_fee
FROM universities as u
join cities c on c.id = u.city_id
ORDER BY tuition_fee asc;

-- 10
CREATE FUNCTION udf_average_alumi_grade_by_course_name(course_name VARCHAR(60))
    RETURNS DECIMAL(19,2)
    BEGIN
        DECLARE avg_grade DECIMAL(19, 2)
        SELECT AVG(sc.grade)
        INTO avg_grade
        FROM students_courses as sc
        JOIN students as st on sc.student_id = st.id
        JOIN courses as c on c.course_id = c.id
        WHERE c.name = course_name AND st.is_graduated = TRUE;
        RETURN avg_grade
    end;

-- 11

CREATE PROCEDURE udp_graduate_all_students_by_year(year_started INT)
BEGIN
    UPDATE students as s
        JOIN students_courses as sc on s.id = sc.student_id
        JOIN courses as c on sc.course_id = c.id
    set s.is_graduated = 1
    WHERE year(c.start_date) = year_started;
END;


