--- 1

SELECT
    e.employee_id,
    e.job_title,
    a.address_id,
    a.address_text
FROM employees as e
    JOIN addresses as a on e.address_id = a.address_id
ORDER BY e.address_id ASC
LIMIT 5;

-- 2

select
    e.first_name,
    e.last_name,
    t.name as town,
    a.address_text
from employees as e
    JOIN addresses AS a ON e.address_id = a.address_id
    JOIN towns AS t ON a.town_id = t.town_id
ORDER BY
    e.first_name,
    e.last_name
LIMIT 5;

-- 3 for homework

-- 4

-- employee_id, first_name, salary, department_name

select
    e.employee_id,
    e.first_name,
    e.salary,
    d.name as department_name
FROM employees as e
    JOIN departments as d ON e.department_id = d.department_id
WHERE e.salary > 15000
ORDER BY d.department_id DESC
LIMIT 5;

-- 5 for homework

select
    e.employee_id,
    e.first_name,
    ep.project_id
from employees as e
    LEFT JOIN employees_projects as ep on e.employee_id = ep.employee_id
WHERE ep.project_id IS NULL
ORDER BY e.employee_id DESC
limit 3;

-- 6

-- first_name, last_name, hire_date, dept_name

SELECT
    e.first_name,
    e.last_name,
    e.hire_date,
    d.name as dept_name
FROM employees as e
    JOIN departments as d ON e.department_id = d.department_id
WHERE
    e.hire_date > '1999-01-01'
    AND d.name IN ('Sales', 'Finance')
ORDER BY e.hire_date ASC;

-- 7 for homework

-- 8 for homework

--9 for homework

