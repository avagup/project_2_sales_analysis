# Sales & Business Performance Analysis

## Project Overview

This project analyzes sales and business performance for a fictional mid-sized e-commerce company using simulated transactional data covering 2023–2025.

The project combines data cleaning, data validation, exploratory analysis, SQL, Python/Pandas, visualization, and business interpretation to identify patterns in revenue, profitability, customer value, discounting, returns, and geographic performance.

The dataset is simulated for portfolio purposes and does not represent a real company or real customer data.

## Business Objectives

The analysis addresses the following business questions:

- How did revenue, order volume, and profitability change from 2023 to 2025?
- Which product categories and products generate the strongest and weakest margins?
- How is profit distributed across customers and customer segments?
- How does profitability vary across discount levels?
- Are returns and cancellations concentrated in particular categories or sales channels?
- How does customer value vary across geographic markets?
- What actions could improve profitability and support sustainable growth?

  ## Dataset

The project uses three related simulated datasets:

| Dataset | Description | Rows |
|---|---|---:|
| `orders.csv` | Transaction-level order data, including pricing, discounts, costs, revenue, profit, sales channel, and order status | 30,010 raw / 30,000 cleaned |
| `customers.csv` | Customer attributes including segment, location, and customer tenure information | 2,500 |
| `products.csv` | Product attributes including category, subcategory, cost, and base selling price | 72 |

The data covers the period from January 2023 through December 2025.

The raw datasets were intentionally designed with realistic data-quality issues to demonstrate a complete data-cleaning and validation workflow.

## Data Quality & Cleaning

The raw datasets contained several intentional data-quality issues that were identified and addressed during the cleaning process.

### Issues identified

- 10 duplicate order records
- 30 missing customer city values
- 4 missing product unit costs
- 50 missing discount values
- 15 unusual order quantities
- 6,968 orders where the order date occurred before the customer's recorded `customer_since` date

### Cleaning approach

- Exact duplicate order records were removed.
- Missing customer cities were retained because the available state information was not sufficient to reliably infer the city.
- Missing product unit costs were estimated using a regression relationship between `base_price` and `unit_cost`. The estimates were documented rather than treated as recovered source values.
- Missing discounts were derived from the relationship between `unit_price` and `base_price`.
- Unusual quantities were retained because they were valid non-negative values, and derived financial fields were recalculated to maintain internal consistency.
- Orders occurring before the recorded customer start date were retained but flagged for potential use in date-sensitive analyses.
- Revenue, product cost, and profit calculations were validated after cleaning.
- Referential integrity between orders, customers, and products was verified.

The final cleaned datasets contain 30,000 orders, 2,500 customers, and 72 products.


## Analysis

The project uses both Python/Pandas and SQL to analyze the cleaned datasets.

### Python/Pandas Analysis

The business analysis covers:

- Revenue and order trends from 2023–2025
- Monthly revenue patterns and seasonality
- Profitability by category, subcategory, and product
- Customer-level economics and profit concentration
- Customer segment economics
- Discount levels and profitability
- Returns and cancellations
- Geographic performance

Five visualizations are included to highlight the most important trends and comparisons.

### SQL Analysis

The SQL analysis reproduces key business questions using relational queries across the three datasets.

The SQL notebook demonstrates:

- Aggregation and `GROUP BY`
- Table joins
- Conditional logic using `CASE WHEN`
- `HAVING` filters
- Common table expressions (CTEs)
- Window functions using `NTILE()`
- Distinct customer and order counts
- Calculated business metrics

## Key Findings

- Revenue remained broadly stable at approximately ₹365–370M per year from 2023 to 2025, with profit margins remaining close to 24.6%.
- Office Supplies had a substantially lower profit margin of 5.8%, compared with approximately 24.5–25.4% for the other categories.
- Six Office Supplies products were loss-making, four of which belonged to the Writing subcategory.
- The top 10% of customers by cumulative profit contributed 21.2% of total customer profit.
- Profit margin declined consistently across observed discount levels, from 31.5% at 0% discount to 9.0% at 25% discount. This represents an observed association rather than evidence of causality.
- Home Appliances had the highest return rate at 7.7%, although category-level differences in return rates were moderate.
- Maharashtra generated the highest total revenue, primarily reflecting its larger customer base. Differences in revenue per customer across states were moderate.

## Business Recommendations

Based on the observed patterns in revenue, profitability, discounting, and order outcomes, the analysis suggests the following areas for business attention:

### 1. Review the economics of low-value Office Supplies products

Office Supplies has substantially weaker profitability than the other categories, with six loss-making products. Four of these products belong to the Writing subcategory, where the largest individual losses are concentrated.

**Recommendation:** Review pricing, bundling, minimum-order thresholds, and fulfillment costs for the loss-making products. Product-level intervention should be targeted rather than applied across the entire Office Supplies category.

### 2. Use deeper discounts selectively

Profitability declines consistently as discount levels increase. Profit margin falls from 31.5% with no discount to 9.0% at a 25% discount, while profit per order declines from approximately ₹12.7K to ₹2.6K.

**Recommendation:** Use deeper discounts selectively and evaluate them against the sales value they generate. Broad discounting should be approached cautiously because the analysis shows a strong association between higher discounts and lower profitability.

### 3. Investigate Home Appliances returns

Home Appliances has the highest return rate at 7.7%, compared with 6.6% for Electronics. The difference is moderate, so the analysis does not establish a major category-level return problem, but it identifies Home Appliances as an area worth further investigation.

**Recommendation:** Examine return reasons, individual products, and customer feedback within Home Appliances to determine whether specific products or operational issues are contributing to the higher return rate.

### 4. Prioritize profitable growth over order volume alone

Order volume increased modestly between 2023 and 2025, but overall revenue remained broadly stable and revenue per order declined slightly. Profit margin remained stable at approximately 24.6%.

**Recommendation:** Focus growth initiatives on increasing order value and improving product mix while maintaining profitability, rather than pursuing order volume without considering its impact on revenue per order and margins.

## Tools & Skills

- **Python:** Pandas, data cleaning, data validation, exploratory data analysis
- **SQL:** SQLite, joins, aggregations, conditional logic, CTEs, window functions
- **Visualization:** Matplotlib
- **Data analysis:** Revenue analysis, profitability analysis, customer segmentation, discount analysis, return analysis, geographic analysis
- **Business analysis:** Identifying business issues, interpreting quantitative patterns, developing data-driven recommendations

## Project Structure

```text
project_2_sales_analysis/
│
├── README.md
│
├── data/
│   ├── raw/
│   │   ├── orders.csv
│   │   ├── customers.csv
│   │   └── products.csv
│   │
│   └── cleaned/
│       ├── orders_clean.csv
│       ├── customers_clean.csv
│       └── products_clean.csv
│
├── notebooks/
│   ├── 01_data_cleaning.ipynb
│   ├── 02_business_analysis.ipynb
│   └── 03_sql_analysis.ipynb
│
├── sql/
│   └── sales_analysis.sql
│
└── outputs/
    └── charts/
