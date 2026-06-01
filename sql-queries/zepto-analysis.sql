-- ==========================================
-- ZEPTO INVENTORY ANALYSIS PROJECT
-- Author: Hiniyasri P
-- Database: zepto_analysis
-- ==========================================

-- ==========================================
-- 1. DATABASE EXPLORATION
-- ==========================================

-- Total Products
SELECT COUNT(*) AS total_products
FROM zepto_v2;

-- Unique Products
SELECT COUNT(DISTINCT product_name) AS unique_products
FROM zepto_v2;

-- Total Categories
SELECT COUNT(DISTINCT category) AS total_categories
FROM zepto_v2;


-- ==========================================
-- 2. DATA QUALITY CHECKS
-- ==========================================

-- Missing Values Check
SELECT *
FROM zepto_v2
WHERE category IS NULL
   OR product_name IS NULL;

-- Duplicate Products
SELECT
    product_name,
    COUNT(*) AS duplicate_count
FROM zepto_v2
GROUP BY product_name
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


-- ==========================================
-- 3. INVENTORY ANALYSIS
-- ==========================================

-- Total Stock Available by Category
SELECT
    category,
    SUM(available_quantity) AS total_stock
FROM zepto_v2
GROUP BY category
ORDER BY total_stock DESC;

-- Inventory Value by Category
SELECT
    category,
    SUM(discounted_selling_price * available_quantity) AS inventory_value
FROM zepto_v2
GROUP BY category
ORDER BY inventory_value DESC;

-- Insight:
-- Cooking Essentials has the highest inventory value.


-- ==========================================
-- 4. STOCK AVAILABILITY ANALYSIS
-- ==========================================

-- Out-of-Stock Products Count
SELECT
    COUNT(*) AS out_of_stock_products
FROM zepto_v2
WHERE out_of_stock = TRUE;

-- Out-of-Stock Percentage
SELECT
    ROUND(
        (
            COUNT(CASE WHEN out_of_stock = TRUE THEN 1 END) * 100.0
        ) / COUNT(*),
        2
    ) AS stockout_percentage
FROM zepto_v2;

-- Stockout Rate by Category
SELECT
    category,
    COUNT(CASE WHEN out_of_stock = TRUE THEN 1 END) AS out_of_stock_products,
    COUNT(*) AS total_products,
    ROUND(
        COUNT(CASE WHEN out_of_stock = TRUE THEN 1 END) * 100.0
        / COUNT(*),
        2
    ) AS stockout_percentage
FROM zepto_v2
GROUP BY category
ORDER BY stockout_percentage DESC;

-- Insight:
-- Biscuits category has the highest stockout rate.


-- ==========================================
-- 5. PRICING ANALYSIS
-- ==========================================

-- Top 10 Most Expensive Products
SELECT
    product_name,
    mrp
FROM zepto_v2
ORDER BY mrp DESC
LIMIT 10;

-- Product Price Range
SELECT
    MIN(discounted_selling_price) AS min_price,
    MAX(discounted_selling_price) AS max_price
FROM zepto_v2;


-- ==========================================
-- 6. DISCOUNT ANALYSIS
-- ==========================================

-- Average Discount by Category
SELECT
    category,
    ROUND(AVG(discount_percentage), 2) AS avg_discount
FROM zepto_v2
GROUP BY category
ORDER BY avg_discount DESC;

-- Products with More Than 50% Discount
SELECT
    product_name,
    mrp,
    discounted_selling_price,
    discount_percentage
FROM zepto_v2
WHERE discount_percentage > 50
ORDER BY discount_percentage DESC;

-- Insight:
-- Dukes Waffy products received the highest discounts.


-- ==========================================
-- 7. SAVINGS ANALYSIS
-- ==========================================

-- Top Products Offering Maximum Savings
SELECT
    product_name,
    mrp,
    discounted_selling_price,
    (mrp - discounted_selling_price) AS savings
FROM zepto_v2
ORDER BY savings DESC
LIMIT 10;

-- Insight:
-- Borges Extra Light Olive Oil provides the highest savings.


-- ==========================================
-- 8. CATEGORY PERFORMANCE ANALYSIS
-- ==========================================

-- Number of Products in Each Category
SELECT
    category,
    COUNT(*) AS total_products
FROM zepto_v2
GROUP BY category
ORDER BY total_products DESC;

-- Top 5 Categories by Inventory Value
SELECT
    category,
    SUM(discounted_selling_price * available_quantity) AS revenue_potential
FROM zepto_v2
GROUP BY category
ORDER BY revenue_potential DESC
LIMIT 5;

-- Insight:
-- Cooking Essentials leads in inventory value and revenue potential.


-- ==========================================
-- PROJECT SUMMARY
-- ==========================================

-- Key Findings:
-- 1. Cooking Essentials has the highest inventory value.
-- 2. Biscuits category shows the highest stockout percentage.
-- 3. Dukes Waffy products received the highest discounts.
-- 4. Borges Extra Light Olive Oil offers the highest savings.
-- 5. Inventory value is concentrated in a few major categories.
