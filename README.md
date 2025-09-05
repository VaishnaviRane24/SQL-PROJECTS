# SQL-PROJECTS

## Inventory & Warehouse Management System

### Objective
Design a SQL backend to manage warehouse inventory, suppliers, and stock levels with automated alerts and stock transfer capabilities.

### Tools Used
- MySQL Workbeach

### Schema Overview
- **Suppliers**: Stores supplier contact details.
- **Products**: Contains product info and reorder thresholds.
- **Warehouses**: Tracks warehouse locations.
- **Stock**: Manages product quantities per warehouse.

### Sample Data
Includes entries for:
- 2 suppliers
- 3 products
- 2 warehouses
- Initial stock distribution across warehouses

### Key Queries
- **Stock Levels**: View current inventory by product and warehouse.
- **Reorder Alerts**: Identify products below reorder threshold.

### Trigger
- **low_stock_alert**: Fires after stock updates if quantity drops below reorder level. Raises a custom SQL error with product and warehouse info.

### Stored Procedure
- **TransferStock**: Moves stock between warehouses. Validates availability and updates quantities accordingly.

### Deliverables
- SQL schema (DDL)
- Sample data (DML)
- Inventory queries
- Trigger and stored procedure
- Documentation (this README)

---

## Online Retail Sales Database

### Objective
Create a normalized SQL schema for an e-commerce platform to manage customers, orders, payments, and product inventory.

### Tools Used
- MySQL Workbeach
- ER diagram tool: dbdiagram.io 

### Schema Overview
- **Customers**: Personal and contact details.
- **Products**: Catalog with pricing and stock.
- **Orders**: Tracks purchases and status.
- **Order_Items**: Line items per order.
- **Payments**: Payment method and amount per order.

### Sample Data
Includes:
- 2 customers
- 3 products
- 2 orders with associated items
- Payment records for each order

### Key Queries
- **Order Summary**: List orders with customer details.
- **Order Details**: Show products per order.
- **Sales Report**: Total units sold and revenue per product.
- **Payment Summary**: Payment method and amount per order.

### Deliverables
- SQL schema (DDL)
- Sample data (DML)
- Query report
- ER diagram (optional)
- Documentation (this README)

---
