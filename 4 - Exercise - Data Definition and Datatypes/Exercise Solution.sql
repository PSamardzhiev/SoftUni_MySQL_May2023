create database minions;
use minions;

-- 1
CREATE TABLE minions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(47) NOT NULL,
    age INT 
);

CREATE table towns (
town_id int primary key AUTO_INCREMENT,
name varchar(47)
);

-- 2 (rename town_id to id in table towns)
alter table towns
rename COLUMN town_id TO id;

alter table minions
add CONSTRAINT fk_minions_towns -- fk_(table where we want to position the foreign key)_(table where we want to reffer)
FOREIGN KEY minions(town_id)
references towns(id);


insert into towns(name)
values
('Sofia'),
('Plovdiv'),
('Varna');

insert into minions(name, age, town_id)
values
('Kevin', 22, 1),
('Bob', 15, 3),
('Steward', NULL, 2);



select * from minions; -- for quick checks

-- 4

TRUNCATE TABLE minions; -- truncate means delete all data from a given table


-- 5
drop table minions;
drop table towns;


-- 6
-- • id – unique number for every person there will be no more than 231-1people. (Auto incremented)
-- • name – full name of the person will be no more than 200 Unicode characters. (Not null)
-- • picture – image with size up to 2 MB. (Allow nulls)
-- • height – In meters. Real number precise up to 2 digits after floating point. (Allow nulls)
-- • weight – In kilograms. Real number precise up to 2 digits after floating point. (Allow nulls)
-- • gender – Possible states are m or f. (Not null)
-- • birthdate – (Not null)
-- • biography – detailed biography of the person it can contain max allowed Unicode characters. (llow nulls)

create table people (
	id int primary key UNIQUE AUTO_INCREMENT,
    name varchar(200) not null,
    picture blob,
    height double(10,2),
    weight double(10,2),
    gender char(1) not null,
    birthdate date not null,
    biography text
);

insert into people (name, gender, birthdate)
values
('petko', 'm', DATE(NOW())),
('totko', 'm', DATE(NOW())),
('mitko', 'm', DATE(NOW())),
('Desi', 'f', DATE(NOW())),
('Aleks', 'f', DATE(NOW()));

select * from people; -- just to check if the data is populated in our people table

-- 7

-- • id – unique number for every user. There will be no more than 263-1 users. (Auto incremented)
-- • username – unique identifier of the user will be no more than 30 characters (non Unicode). (Required)
-- • password – password will be no longer than 26 characters (non Unicode). (Required)
-- • profile_picture – image with size up to 900 KB. 
-- • last_login_time
-- • is_deleted – shows if the user deleted his/her profile. Possible states are true or false.



create table users (
	id int primary key AUTO_INCREMENT,
    username varchar(30) not null,
    `password` varchar(26),
    profile_picture blob,
    last_login_time TIME,
    is_deleted BOOLEAN
);
INSERT INTO `users` (`username`, `password`)
VALUES 
('Test1', 'Pass'),
('Test2', 'Pass'),
('Test3', 'Pass'),
('Test4', 'Pass'),
('Test5', 'Pass');

select * from users; -- for check!

-- 8

ALTER TABLE users
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users
PRIMARY KEY users(id, username);

-- 9

alter table users
change COLUMN last_login_time last_login_time DATETIME DEFAULT NOW();

-- 10
ALTER TABLE users
DROP PRIMARY KEY,
add constraint pk_users
primary key users(id),
CHANGE COLUMN `username` `username` varchar(50) unique;

-- 11
create database movies;
use movies;
create table directors (
	id int primary key auto_increment,
    director_name varchar(50) not null,
    notes text
);

create table genres (
	id int primary key auto_increment,
    genre_name varchar(50) not null,
    notes TEXT
);

create table categories (
	id int primary key auto_increment,
    category_name varchar(50) not null,
    notes TEXT
);

create table movies (
	id int primary key auto_increment,
    title varchar(50) not null,
    director_id INT,
    copyright_year YEAR,
    lenght double(10,2),
    genre_id INT,
    category_id INT,
    rating double(7,2),
    notes text,
    CONSTRAINT fk_director_directors Foreign key (director_id)
    REFERENCES directors(id),
    CONSTRAINT fk_genre_genres Foreign key (genre_id)
    references genres(id),
    CONSTRAINT fk_category_categories foreign key (category_id)
    references categories(id)
);
INSERT INTO `directors`(`director_name`, `notes`)
VALUES 
('TestName1', 'TestNotes'),
('TestName2', 'TestNotes'),
('TestName3', 'TestNotes'),
('TestName4', 'TestNotes'),
('TestName5', 'TestNotes');

INSERT INTO `genres`(`genre_name`, `notes`)
VALUES 
('TestName1', 'TestNotes'),
('TestName2', 'TestNotes'),
('TestName3', 'TestNotes'),
('TestName4', 'TestNotes'),
('TestName5', 'TestNotes');

INSERT INTO `categories`(`category_name`, `notes`)
VALUES 
('TestName1', 'TestNotes'),
('TestName2', 'TestNotes'),
('TestName3', 'TestNotes'),
('TestName4', 'TestNotes'),
('TestName5', 'TestNotes');

INSERT INTO `movies` (`title`)
VALUES 
('TestMovie1'),
('TestMovie2'),
('TestMovie3'),
('TestMovie4'),
('TestMovie5');

create database car_rental;
use car_rental;

create table categories (
	id int primary key auto_increment,
    category varchar(50),
    daily_rate double,
    weekly_rate double,
    monthly_rate double,
    weekend_rate double
);

create table cars (
	id int primary key auto_increment,
    plate_number VARCHAR(20),
    make varchar(20),
    model varchar(20),
    car_year year,
    category_id int,
    doors INT,
    picture blob,
    car_condition varchar(50),
    vailable BOOLEAN,
    CONSTRAINT fk_cars_categories
    FOREIGN KEY (category_id) 
    references categories(id)
);

create table employees (
	id int primary key auto_increment,
    first_name varchar(50),
    last_name varchar(50),
    title varchar(50),
    notes text
);

create table customers (
	id int primary key auto_increment,
    driver_license_number varchar(50),
    full_name varchar(100),
    city varchar(50),
    zip_code varchar(50),
    notes text
);

create table rental_orders (
	id int primary key auto_increment,
    employee_id int,
    customer_id int,
    car_id int,
    car_condition varchar(30),
    tank_level varchar(20),
    kilometrage_start int,
    kilometrage_end int,
    total_kilometrage int,
    start_date date,
    end_date date,
    total_days int,
    rate_applied double,
    tax_rate double,
    order_status varchar(50),
    notes text,
	CONSTRAINT fk_orders_employees FOREIGN KEY rental_orders(employee_id) REFERENCES employees(id),
	CONSTRAINT fk_orders_customers FOREIGN KEY rental_orders(customer_id) REFERENCES customers(id),
    CONSTRAINT fk_orders_cars FOREIGN KEY rental_orders(car_id) references cars(id)
);
drop table rental_orders;

INSERT INTO `categories` (`category`)
VALUES 
('TestName1'),
('TestName2'),
('TestName3');

INSERT INTO `cars` (`plate_number`)
VALUES 
('TestName1'),
('TestName2'),
('TestName3');

INSERT INTO `employees` (`first_name`, `last_name`)
VALUES 
('TestName1', 'TestName1'),
('TestName2', 'TestName2'),
('TestName3', 'TestName3');

INSERT INTO `customers` (`driver_license_number`, `full_name`)
VALUES 
('TestName1', 'TestName1'),
('TestName2', 'TestName2'),
('TestName3', 'TestName3');

INSERT INTO `rental_orders` (`employee_id`, `customer_id`)
VALUES 
(1, 2),
(2, 3),
(3, 1);
