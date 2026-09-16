-- SQL Sales & Business Analysis

-- 1. Annual Business Performance

SELECT
    strftime('%Y', order_date) AS year,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(revenue) AS total_revenue,
    SUM(profit) AS total_profit,
    ROUND(
        SUM(profit) * 100.0 / SUM(revenue),
        2
    ) AS profit_margin
FROM orders
GROUP BY year
ORDER BY year;

-- 2. Category Profitability

SELECT
    p.category,
    SUM(o.revenue) AS total_revenue,
    SUM(o.profit) AS total_profit,
    ROUND(
        SUM(o.profit) * 100.0 / SUM(o.revenue),
        2
    ) AS profit_margin
FROM orders AS o
JOIN products AS p
    ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY profit_margin DESC;

-- 3. Office Supplies Subcategory Profitability

SELECT
    p.subcategory,
    SUM(o.revenue) AS total_revenue,
    SUM(o.profit) AS total_profit,
    ROUND(
        SUM(o.profit) * 100.0 / SUM(o.revenue),
        2
    ) AS profit_margin
FROM orders AS o
JOIN products AS p
    ON o.product_id = p.product_id
WHERE p.category = 'Office Supplies'
GROUP BY p.subcategory
ORDER BY profit_margin;

-- 4. Loss-Making Office Supplies Products

SELECT
    p.product_id,
    p.product_name,
    p.subcategory,
    SUM(o.revenue) AS total_revenue,
    SUM(o.profit) AS total_profit,
    ROUND(
        SUM(o.profit) * 100.0 / SUM(o.revenue),
        2
    ) AS profit_margin
FROM orders AS o
JOIN products AS p
    ON o.product_id = p.product_id
WHERE p.category = 'Office Supplies'
GROUP BY
    p.product_id,
    p.product_name,
    p.subcategory
HAVING SUM(o.profit) < 0
ORDER BY total_profit;

-- 5. Customer-Level Economics

SELECT
    o.customer_id,
    c.customer_segment,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.revenue) AS total_revenue,
    SUM(o.profit) AS total_profit,
    ROUND(
        SUM(o.profit) * 100.0 / SUM(o.revenue),
        2
    ) AS profit_margin
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id
GROUP BY
    o.customer_id,
    c.customer_segment
ORDER BY total_profit DESC;

-- 6. Customer Profit Concentration

WITH customer_profit AS (
    SELECT
        customer_id,
        SUM(profit) AS total_profit
    FROM orders
    GROUP BY customer_id
),

ranked_customers AS (
    SELECT
        customer_id,
        total_profit,
        NTILE(10) OVER (
            ORDER BY total_profit DESC
        ) AS profit_decile
    FROM customer_profit
)

SELECT
    ROUND(
        SUM(
            CASE
                WHEN profit_decile = 1
                THEN total_profit
                ELSE 0
            END
        ) * 100.0
        / SUM(total_profit),
        2
    ) AS top_10_profit_share
FROM ranked_customers;

-- 7. Customer Segment Economics

SELECT
    c.customer_segment,
    COUNT(DISTINCT c.customer_id) AS customers,
    SUM(o.revenue) AS total_revenue,
    SUM(o.profit) AS total_profit,
    ROUND(
        SUM(o.revenue) * 1.0
        / COUNT(DISTINCT c.customer_id),
        2
    ) AS revenue_per_customer,
    ROUND(
        SUM(o.profit) * 1.0
        / COUNT(DISTINCT c.customer_id),
        2
    ) AS profit_per_customer,
    ROUND(
        SUM(o.profit) * 100.0
        / SUM(o.revenue),
        2
    ) AS profit_margin
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_segment
ORDER BY profit_per_customer DESC;

-- 8. Profitability by Discount Level

SELECT
    ROUND(discount_pct * 100, 0) AS discount_level,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(revenue) AS total_revenue,
    SUM(profit) AS total_profit,
    ROUND(
        SUM(profit) * 100.0 / SUM(revenue),
        2
    ) AS profit_margin,
    ROUND(
        SUM(revenue) * 1.0 / COUNT(DISTINCT order_id),
        2
    ) AS revenue_per_order,
    ROUND(
        SUM(profit) * 1.0 / COUNT(DISTINCT order_id),
        2
    ) AS profit_per_order
FROM orders
GROUP BY discount_pct
ORDER BY discount_pct;

-- 9. Order Outcomes by Category

SELECT
    p.category,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM( DISTINCT
        CASE
            WHEN o.order_status = 'Completed' THEN 1
            ELSE 0
        END
    ) AS completed_orders,
    SUM( DISTINCT
        CASE
            WHEN o.order_status = 'Returned' THEN 1
            ELSE 0
        END
    ) AS returned_orders,
    SUM( DISTINCT
        CASE
            WHEN o.order_status = 'Cancelled' THEN 1
            ELSE 0
        END
    ) AS cancelled_orders,
    ROUND(
        SUM(
            CASE
                WHEN o.order_status = 'Returned' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(DISTINCT o.order_id),
        2
    ) AS return_rate,
    ROUND(
        SUM(
            CASE
                WHEN o.order_status = 'Cancelled' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(DISTINCT o.order_id),
        2
    ) AS cancellation_rate
FROM orders AS o
JOIN products AS p
    ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY return_rate DESC;

-- 10. Order Outcomes by Sales Channel

SELECT
    sales_channel,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM( DISTINCT
        CASE
            WHEN order_status = 'Completed' THEN 1
            ELSE 0
        END
    ) AS completed_orders,
    SUM( DISTINCT
        CASE
            WHEN order_status = 'Returned' THEN 1
            ELSE 0
        END
    ) AS returned_orders,
    SUM( DISTINCT
        CASE
            WHEN order_status = 'Cancelled' THEN 1
            ELSE 0
        END
    ) AS cancelled_orders,
    ROUND(
        SUM(
            CASE
                WHEN order_status = 'Returned' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(DISTINCT order_id),
        2
    ) AS return_rate,
    ROUND(
        SUM(
            CASE
                WHEN order_status = 'Cancelled' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(DISTINCT order_id),
        2
    ) AS cancellation_rate
FROM orders
GROUP BY sales_channel
ORDER BY sales_channel;

-- 11. Geographic Performance

SELECT
    c.state,
    COUNT(DISTINCT c.customer_id) AS customers,
    SUM(o.revenue) AS total_revenue,
    SUM(o.profit) AS total_profit,
    ROUND(
        SUM(o.revenue) * 1.0
        / COUNT(DISTINCT c.customer_id),
        2
    ) AS revenue_per_customer
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id
GROUP BY c.state
ORDER BY total_revenue DESC;

