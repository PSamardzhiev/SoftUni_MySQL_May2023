-- 0

CREATE DATABASE gamebar;

-- 1

USE DATABASE gamebar;

CREATE TABLE employees (
  	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
  	first_name VARCHAR(30) NOT NULL,
  	last_name VARCHAR(30) NOT NULL
);

CREATE TABLE categories (
  	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
  	name VARCHAR(30) NOT NULL
);
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    name VARCHAR(255) NOT NULL,
    category_id INT
);

-- 2

insert into employees (id, first_name, last_name) 
values 
(1,'test','test'),
(2,'test','test'),
(3,'test','test');

-- 3

alter table employees
add column middle_name varchar(30);

-- 4

ALTER TABLE products
ADD CONSTRAINT fk_products_categories
FOREIGN KEY (category_id)
REFERENCES categories (id);

-- 5

ALTER TABLE employees
MODIFY COLUMN middle_name VARCHAR(100);