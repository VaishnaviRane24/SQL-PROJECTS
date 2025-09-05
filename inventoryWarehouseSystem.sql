-- 1. CREATE DATABASE
DROP DATABASE IF EXISTS inventory_warehouse_system;
CREATE DATABASE inventory_warehouse_system;
USE inventory_warehouse_system;

-- 2. CREATE TABLES

-- Suppliers Table
CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100),
    phone VARCHAR(20)
);

-- Products Table
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    supplier_id INT,
    reorder_level INT DEFAULT 10,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

-- Warehouses Table
CREATE TABLE Warehouses (
    warehouse_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(255)
);

-- Stock Table
CREATE TABLE Stock (
    stock_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    warehouse_id INT,
    quantity INT DEFAULT 0,
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouses(warehouse_id),
    UNIQUE (product_id, warehouse_id)
);

-- 3. Sample Data

-- Suppliers
INSERT INTO Suppliers (name, contact_email, phone) VALUES
('Global Supplies Inc.', 'contact@globalsupplies.com', '9876543210'),
('TechParts Co.', 'sales@techparts.com', '9123456780');

-- Products
INSERT INTO Products (name, description, supplier_id, reorder_level) VALUES
('Laptop', '15-inch display, 8GB RAM', 1, 5),
('Mouse', 'Wireless optical mouse', 2, 20),
('Keyboard', 'Mechanical keyboard', 2, 15);

-- Warehouses
INSERT INTO Warehouses (name, location) VALUES
('Central Depot', 'Mumbai'),
('East Hub', 'Kolkata');

-- Stock
INSERT INTO Stock (product_id, warehouse_id, quantity) VALUES
(1, 1, 10),
(2, 1, 5),
(3, 2, 25),
(1, 2, 3);

-- 4. Inventory Queries

-- A. Check stock levels
SELECT p.name AS product, w.name AS warehouse, s.quantity
FROM Stock s
JOIN Products p ON s.product_id = p.product_id
JOIN Warehouses w ON s.warehouse_id = w.warehouse_id;

-- B. Reorder alerts
SELECT p.name AS product, w.name AS warehouse, s.quantity, p.reorder_level
FROM Stock s
JOIN Products p ON s.product_id = p.product_id
JOIN Warehouses w ON s.warehouse_id = w.warehouse_id
WHERE s.quantity < p.reorder_level;

-- 5. Trigger: Low Stock Notification
DELIMITER //

CREATE TRIGGER low_stock_alert
AFTER UPDATE ON Stock
FOR EACH ROW
BEGIN
    DECLARE prod_name VARCHAR(100);
    DECLARE warehouse_name VARCHAR(100);
    DECLARE alert_message TEXT;

    SELECT name INTO prod_name FROM Products WHERE product_id = NEW.product_id;
    SELECT name INTO warehouse_name FROM Warehouses WHERE warehouse_id = NEW.warehouse_id;

    IF NEW.quantity < (SELECT reorder_level FROM Products WHERE product_id = NEW.product_id) THEN
        SET alert_message = CONCAT('Low stock alert: ', prod_name, ' in ', warehouse_name);
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = alert_message;
    END IF;
END;
//

DELIMITER ;

-- 6. Stored Procedure: Transfer Stock
DELIMITER //

CREATE PROCEDURE TransferStock(
    IN prod_id INT,
    IN from_wh INT,
    IN to_wh INT,
    IN qty INT
)
BEGIN
    DECLARE current_qty INT;

    SELECT quantity INTO current_qty
    FROM Stock
    WHERE product_id = prod_id AND warehouse_id = from_wh;

    IF current_qty < qty THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock to transfer';
    ELSE
        UPDATE Stock
        SET quantity = quantity - qty
        WHERE product_id = prod_id AND warehouse_id = from_wh;

        INSERT INTO Stock (product_id, warehouse_id, quantity)
        VALUES (prod_id, to_wh, qty)
        ON DUPLICATE KEY UPDATE quantity = quantity + qty;
    END IF;
END;
//

DELIMITER ;
