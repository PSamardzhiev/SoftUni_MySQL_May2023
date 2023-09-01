drop database store;
create database store;
use store;
-- Judge 1 --
CREATE TABLE brands
(
    id   INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE categories
(
    id   INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE

);

CREATE TABLE reviews
(
    id           INT PRIMARY KEY AUTO_INCREMENT,
    content      TEXT,
    rating       DECIMAL(10, 2) NOT NULL,
    picture_url  VARCHAR(80)    NOT NULL,
    published_at DATETIME       NOT NULL
);

CREATE TABLE products
(
    id                INT PRIMARY KEY AUTO_INCREMENT,
    name              VARCHAR(40)    NOT NULL,
    price             DECIMAL(19, 2) NOT NULL,
    quantity_in_stock INT,
    description       TEXT,
    brand_id          INT            NOT NULL,
    category_id       INT            NOT NULL,
    review_id         INT,
    CONSTRAINT fk_products_brand
        FOREIGN KEY (brand_id)
            REFERENCES brands (id),

    CONSTRAINT fk_products_categories
        FOREIGN KEY (category_id)
            REFERENCES categories (id),

    CONSTRAINT fk_products_reviews
        FOREIGN KEY (review_id)
            REFERENCES reviews (id)
);

CREATE TABLE customers
(
    id            INT PRIMARY KEY AUTO_INCREMENT,
    first_name    VARCHAR(20) NOT NULL,
    last_name     VARCHAR(20) NOT NULL,
    phone         VARCHAR(30) NOT NULL UNIQUE,
    address       VARCHAR(60) NOT NULL,
    discount_card BIT         NOT NULL DEFAULT 0
);

CREATE TABLE orders
(
    id             int primary key auto_increment,
    order_datetime datetime not null,
    customer_id    INT      NOT NULL,

    CONSTRAINT fk_orders_customers
        FOREIGN KEY (customer_id)
            references customers(id)

);


CREATE TABLE orders_products
(
    order_id   INT,
    product_id INT,

    CONSTRAINT fk_op_orders
        FOREIGN KEY (order_id)
            REFERENCES orders (id),

    CONSTRAINT fk_op_products
        FOREIGN KEY (product_id)
            REFERENCES products (id)
);

-- Judge 2 --
# INSERT
# You will have to insert records of data into the reviews table, based on the products table.
#     For products with id equal or greater than 5, insert data in the reviews table with the following values:
#     •	content – set it to the first 15 characters from the description of the product.
# •	picture_url – set it to the product's name but reversed.
# •	published_at – set it to 10-10-2010.
# •	rating – set it to the price of the product divided by 8.

INSERT INTO reviews (content, rating, picture_url, published_at)
SELECT LEFT(p.description, 15), p.price/8, REVERSE(p.name), DATE('2010/10/10')
FROM products as p
WHERE p.ID >= 5;

# UPDATE
# Reduce all products quantity by 5 for products with quantity equal to or greater than 60 and less than 70 (inclusive).

update products as p
SET p.quantity_in_stock  = p.quantity_in_stock - 5
WHERE p.quantity_in_stock between 60 and 70;

# DELETE
# Delete all customers, who didn't order anything.

delete c from customers as c
LEFT JOIN orders o on c.id = o.customer_id
WHERE o.customer_id IS NULL;

-- option 2
DELETE from customers
WHERE id not in (select distinct customer_id from orders);

# QUERY SECTION TASKS 5 - 9
-- 5
SELECT id, name FROM categories
ORDER BY name DESC ;
-- 6

SELECT
    id as product,
    brand_id,
    name as product,
    quantity_in_stock
from products
WHERE price > 1000 and quantity_in_stock < 30
order by quantity_in_stock, id;

-- 7

select
    id,
    content,
    rating,
    picture_url,
    published_at
from reviews
WHERE content regexp '^My'and CHAR_LENGTH(content) > 61
ORDER BY rating desc ;


-- 8

select
    concat_ws(' ',first_name,last_name) as full_name,
    address,
    order_datetime as order_date
from customers as c
left join orders o on c.id = o.customer_id
WHERE YEAR(order_datetime) <= 2018
ORDER BY full_name DESC;

-- 9

SELECT
    count(c.id) as item_count,
    c.name as name,
    sum(p.quantity_in_stock) as total_quantity

from products as p
join categories c on p.category_id = c.id
GROUP BY c.id
ORDER BY item_count DESC,total_quantity ASC
LIMIT 5;


-- 10

CREATE FUNCTION udf_customer_products_count(name VARCHAR(30))
    RETURNS INT
    DETERMINISTIC
    RETURN (
    SELECT COUNT(c.id)
            FROM customers AS c
                     JOIN orders AS o ON c.id = o.customer_id
                     JOIN orders_products op ON o.id = op.order_id
            WHERE c.first_name = name
            GROUP BY c.id
            );

-- 11
CREATE PROCEDURE udp_reduce_price(category_name VARCHAR(50))
BEGIN
    update products as p
        join reviews r on p.review_id = r.id
        join categories c on p.category_id = c.id
    set p.price = p.price * 0.7
    WHERE c.name = category_name
      and r.rating < 4;
END;
