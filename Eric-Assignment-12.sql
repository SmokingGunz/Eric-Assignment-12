create database pizza_restaurant;

create table customers (
customer_id int not null,
`name` varchar (100) not null,
phone_number varchar(20) not null,
PRIMARY KEY (customer_id)
);

CREATE TABLE `pizza_restaurant`.`orders` (
  `order_id` INT NOT NULL,
  `order_date` DATETIME NOT NULL,
  PRIMARY KEY (`order_id`));
  
  CREATE TABLE pizzas (
  `pizza_id` INT NOT NULL,
  `type` varchar(100) NOT NULL,
  `price` DECIMAL (6,2) NOT NULL,
  PRIMARY KEY (pizza_id)
  );
  
  CREATE TABLE customer_orders (
  `customer_id` INT NOT NULL,
  `order_id` INT NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
  FOREIGN KEY (order_id) REFERENCES orders (order_id)
  );
  
  CREATE TABLE pizza_orders (
  `order_id` INT NOT NULL,
  `pizza_id` INT NOT NULL,
  `quantity` INT NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders (order_id),
  FOREIGN KEY (pizza_id) REFERENCES pizzas (pizza_id)
  );

select * from customers;
  
insert into customers (customer_id, `name`, phone_number)
values (1, 'Trevor Page', '226-555-4982');
  
insert into customers (customer_id, `name`, phone_number)
values (2, 'John Doe', '555-555-9498');
  
select * from orders;
  
insert into orders (order_id, order_date)
values (1, '2014-09-10 9:47:00');

insert into orders (order_id, order_date)
values (2, '2014-09-10 13:20:00');

insert into orders (order_id, order_date)
values (3, '2014-09-10 09:47:00');

select * from pizzas;

insert into pizzas (pizza_id, type, price)
values (1, 'Pepperoni & Cheese', 7.99);

insert into pizzas (pizza_id, type, price)
values (2, 'Vegetarian', 9.99);

insert into pizzas (pizza_id, type, price)
values (3, 'Meat Lovers', 14.99);

insert into pizzas (pizza_id, type, price)
values (4, 'Hawaiian', 12.99);

select * from customer_orders;

insert into customer_orders (customer_id, order_id)
values (1, 1);

insert into customer_orders (customer_id, order_id)
values (2, 2);

insert into customer_orders (customer_id, order_id)
values (1, 3);

select * from  pizza_orders;

insert into pizza_orders (order_id, pizza_id, quantity)
values (1, 1, 1);

insert into pizza_orders (order_id, pizza_id, quantity)
values (1, 3, 1);

insert into pizza_orders (order_id, pizza_id, quantity)
values (2, 2, 1);

insert into pizza_orders (order_id, pizza_id, quantity)
values (2, 3, 2);

insert into pizza_orders (order_id, pizza_id, quantity)
values (3, 3, 1);

insert into pizza_orders (order_id, pizza_id, quantity)
values (3, 4, 1);

-- Merged info into one table
select customers.customer_id, customers.name, customers.phone_number, orders.order_id, orders.order_date, 
pizzas.pizza_id, pizzas.type, pizzas.price, pizza_orders.quantity from customers
JOIN customer_orders ON customers.customer_id = customer_orders.customer_id
JOIN orders ON customer_orders.order_id = orders.order_id
JOIN pizza_orders ON orders.order_id = pizza_orders.order_id
JOIN pizzas ON pizza_orders.pizza_id = pizzas.pizza_id;


-- Answer Q4 - Write a SQL query which will tell them how much money each individual customer has spent at their restaurant
SELECT customers.customer_id, customers.name,
    SUM(pizzas.price * pizza_orders.quantity) AS total_spent
FROM customers
JOIN customer_orders ON customers.customer_id = customer_orders.customer_id
JOIN orders ON customer_orders.order_id = orders.order_id
JOIN pizza_orders ON orders.order_id = pizza_orders.order_id
JOIN pizzas ON pizza_orders.pizza_id = pizzas.pizza_id
GROUP BY customers.customer_id, customers.name
ORDER BY total_spent DESC;


-- Answer Q5 - Modify the query from Q4 to separate the orders not just by customer, but also by date so they can see how much each customer is ordering on which date.
SELECT customers.customer_id, customers.name, DATE(orders.order_date) AS order_date,
    SUM(pizzas.price * pizza_orders.quantity) AS total_spent
FROM customers
JOIN customer_orders ON customers.customer_id = customer_orders.customer_id
JOIN orders ON customer_orders.order_id = orders.order_id
JOIN pizza_orders ON orders.order_id = pizza_orders.order_id
JOIN pizzas ON pizza_orders.pizza_id = pizzas.pizza_id
GROUP BY customers.customer_id, customers.name, DATE(orders.order_date)
ORDER BY order_date ASC, total_spent DESC;
