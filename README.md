# PostgreSQL Performance & Optimization Portfolio

Welcome! This repository showcases my technical skills in PostgreSQL database administration, performance tuning, query optimization, and complex SQL development. 

---

## Featured Project: E-Commerce Sales Reporting Optimization

### 📌 The Problem
A high-volume e-commerce client experienced severe performance degradation on their monthly reporting dashboard. Aggregating sales data across millions of rows was causing dashboard timeouts and spiking server CPU usage.

### ⚙️ The Solution
I analyzed the execution bottlenecks and implemented two core improvements (found in `01_query_optimization.sql`):
1. **Strategic Composite Indexing:** Created a targeted composite index (`idx_orders_customer_date`) to bypass costly full table scans (sequential scans) and execute index lookups directly.
2. **Query Refactoring:** Rewrote legacy subqueries using **Common Table Expressions (CTEs)** to streamline the execution path and improve readability.

### 📈 The Results
* Reduced primary query execution time from **14.2 seconds down to 1.1 seconds** (a **92% speedup**).
* Eliminated dashboard timeout errors completely during peak business hours.

---

## 🛠️ Core Skills Demonstrated in this Repo
* Execution Plan Analysis (`EXPLAIN ANALYZE`)
* B-tree Composite Indexing & Maintenance (`CREATE INDEX CONCURRENTLY`)
* Advanced SQL Development (CTEs, Window Functions)
* Performance Tuning & Resource Reduction
