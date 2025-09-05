-- 1. Create Database

DROP DATABASE IF EXISTS online_retail_db;
CREATE DATABASE online_retail_db;
USE online_retail_db;

-- 2. Create Tables

-- Customers Table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Products Table
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Pending',
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Order_Items Table (Bridge between Orders and Products)
CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Payments Table
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(20) CHECK (payment_method IN ('Credit Card','Debit Card','UPI','Net Banking','Cash')),
    amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- 3. Insert Sample Data

-- Customers
INSERT INTO Customers (first_name, last_name, email, phone, city, state, zip_code)
VALUES 
('Mariam', 'Smith', 'mariam@324.com', '9876543210', 'Los Angeles', 'CA', '90001'),
('Daniel', 'Brown', 'daniel@261.com', '9876501234', 'New York', 'NY', '10001');

-- Products
INSERT INTO Products (product_name, description, price, stock_quantity)
VALUES
('Laptop', 'Dell Inspiron 15', 55000.00, 10),
('Smartphone', 'Samsung Galaxy S23', 70000.00, 15),
('Headphones', 'Sony WH-1000XM4', 25000.00, 30);

-- Orders
INSERT INTO Orders (customer_id, status, total_amount)
VALUES
(1, 'Completed', 80000.00),
(2, 'Pending', 70000.00);

-- Order_Items
INSERT INTO Order_Items (order_id, product_id, quantity, price)
VALUES
(1, 1, 1, 55000.00),
(1, 3, 1, 25000.00),
(2, 2, 1, 70000.00);

-- Payments
INSERT INTO Payments (order_id, payment_method, amount)
VALUES
(1, 'UPI', 80000.00),
(2, 'Credit Card', 70000.00);

-- 4. Queries

-- A. List all orders with customer details
SELECT o.order_id, c.first_name, c.last_name, o.order_date, o.status, o.total_amount
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id;

-- B. Get order details with products
SELECT o.order_id, p.product_name, oi.quantity, oi.price
FROM Order_Items oi
JOIN Orders o ON oi.order_id = o.order_id
JOIN Products p ON oi.product_id = p.product_id;

-- C. Total sales by product
SELECT p.product_name, SUM(oi.quantity) AS total_sold, SUM(oi.price * oi.quantity) AS revenue
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.product_name;

-- D. Payments summary
SELECT o.order_id, p.payment_method, p.amount, p.payment_date
FROM Payments p
JOIN Orders o ON p.order_id = o.order_id;


