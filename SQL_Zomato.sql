DROP TABLE if exists goldusers_signup;
CREATE TABLE goldusers_signup(userid integer, gold_signup_date date)

INSERT INTO goldusers_signup(userid, gold_signup_date)
VALUES(1, '09-22-2017'),
      (3, '04-21-2017');

DROP TABLE if exists users;
CREATE TABLE users(userid integer, signup_date date); 

INSERT INTO users(userid, signup_date) 
VALUES(1, '09-02-2014'),
      (2, '01-15-2015'),
      (3, '04-11-2014');

DROP TABLE if exists sales;
CREATE TABLE sales(userid integer, created_date date, product_id integer); 

INSERT INTO sales(userid, created_date, product_id) 
VALUES(1, '04-19-2017', 2),
      (3, '12-18-2019', 1),
      (2, '07-20-2020', 3),
      (1, '10-23-2019', 2),
      (1, '03-19-2018', 3),
      (3, '12-20-2016', 2),
      (1, '11-09-2016', 1),
      (1, '05-20-2016', 3),
      (2, '09-24-2017', 1),
      (1, '03-11-2017', 2),
      (1, '03-11-2016', 1),
      (3, '11-10-2016', 1),
      (3, '12-07-2017', 2),
      (3, '12-15-2016', 2),
      (2, '11-08-2017', 2),
      (2, '09-10-2018', 3);

DROP TABLE if exists product;
CREATE TABLE product(product_id integer, product_name text, price integer); 

INSERT INTO product(product_id, product_name, price) 
VALUES(1,'p1',980),
      (2,'p2',870),
      (3,'p3',330);


SELECT * FROM sales;
SELECT * FROM product;
SELECT * FROM goldusers_signup;
SELECT * FROM users;

-- DATA EXPLORATION
-- 1. What is the total amount each customer spent on Zomato?
-- Here, in this question we need to join the 2 tables i.e. sales and product because these 2 tables contains sales amount.
SELECT s.userid, s.product_id, p.price
FROM sales s
INNER JOIN product p
ON s.product_id = p.product_id

SELECT s.userid, SUM(p.price)
FROM sales s
INNER JOIN product p
ON s.product_id = p.product_id
GROUP BY userid

--2. How many days has each customer visited Zomato for each users?
--Here, we need to find what are the distinct dates a particular customer has visited Zomato.
SELECT userid, COUNT(DISTINCT created_date) AS distinct_days
FROM sales
GROUP BY userid

--3. What was the first product purchased by customer?
--A very good question to know why customers are attracted towards our company and which product is gaining more attraction from customers.
SELECT *, RANK() OVER(PARTITION BY userid 
ORDER BY created_date ASC) AS RNK
FROM Sales

SELECT * 
FROM (SELECT *, RANK() OVER(PARTITION BY userid 
ORDER BY created_date ASC) AS RNK
FROM Sales) a 
WHERE RNK = 1

--4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT product_id, COUNT(product_id) AS no_of_products
FROM sales
GROUP BY product_id
ORDER BY no_of_products DESC

SELECT TOP 1 product_id, COUNT(product_id) AS no_of_products
FROM sales
GROUP BY product_id
ORDER BY no_of_products DESC

--Now I am writing a query that how many times this particular product means (product_id = 2) has been purchased
SELECT * 
FROM sales
WHERE product_id = 
(SELECT TOP 1 product_id
FROM sales
GROUP BY product_id
ORDER BY COUNT(product_id) DESC)

--Which item was the most popular for the customer?
--Here, most popular item means the item which is purchased most of the times.
SELECT userid, product_id, COUNT(product_id) AS no_of_times
FROM sales
GROUP BY userid, product_id

SELECT *, RANK() OVER(PARTITION BY userid ORDER BY no_of_times DESC) rnk 
FROM 
(SELECT userid, product_id, COUNT(product_id) AS no_of_times 
FROM sales
GROUP BY userid, product_id)a