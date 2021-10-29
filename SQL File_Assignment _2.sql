/*
Task 1: 
Understanding the data in hand
A. Describe the data in hand in your own words. (Word Limit is 500)
	1. cust_dimen: Details of all the customers
		
        Customer_Name (TEXT): Name of the customer
        Province (TEXT): Province of the customer
        Region (TEXT): Region of the customer
        Customer_Segment (TEXT): Segment of the customer
        Cust_id (TEXT): Unique Customer ID
	
    2. market_fact: Details of every order item sold
		
        Ord_id (TEXT): Order ID
        Prod_id (TEXT): Prod ID
        Ship_id (TEXT): Shipment ID
        Cust_id (TEXT): Customer ID
        Sales (DOUBLE): Sales from the Item sold
        Discount (DOUBLE): Discount on the Item sold
        Order_Quantity (INT): Order Quantity of the Item sold
        Profit (DOUBLE): Profit from the Item sold
        Shipping_Cost (DOUBLE): Shipping Cost of the Item sold
        Product_Base_Margin (DOUBLE): Product Base Margin on the Item sold
        
    3. orders_dimen: Details of every order placed
		
        Order_ID (INT): Order ID
        Order_Date (TEXT): Order Date
        Order_Priority (TEXT): Priority of the Order
        Ord_id (TEXT): Unique Order ID
	
    4. prod_dimen: Details of product category and sub category
		
        Product_Category (TEXT): Product Category
        Product_Sub_Category (TEXT): Product Sub Category
        Prod_id (TEXT): Unique Product ID
	
    5. shipping_dimen: Details of shipping of orders
		
        Order_ID (INT): Order ID
        Ship_Mode (TEXT): Shipping Mode
        Ship_Date (TEXT): Shipping Date
        Ship_id (TEXT): Unique Shipment ID
B. Identify and list the Primary Keys and Foreign Keys for this dataset
	(Hint: If a table don’t have Primary Key or Foreign Key, then specifically mention it in your answer.)
	1. cust_dimen
		Primary Key: Cust_id
        Foreign Key: NA
	
    2. market_fact
		Primary Key: NA
        Foreign Key: Ord_id, Prod_id, Ship_id, Cust_id
	
    3. orders_dimen
		Primary Key: Ord_id
        Foreign Key: NA
	
    4. prod_dimen
		Primary Key: Prod_id, Product_Sub_Category
        Foreign Key: NA
	
    5. shipping_dimen
		Primary Key: Ship_id
        Foreign Key: NA
 */
# TASK - 2
-- 1.Write a query to display the Customer_Name and Customer Segment using alias name “Customer Name", "Customer Segment" from table Cust_dimen.
SELECT 
    Customer_Name AS 'Customer Name',
    Customer_Segment AS 'Customer Segment'
FROM
    superstores.cust_dimen;
-- 2.Write a query to find all the details of the customer from the table cust_dimen order by desc.
SELECT 
    *
FROM
    superstores.cust_dimen
ORDER BY Customer_Name DESC;
-- 3.Write a query to get the Order ID, Order date from table orders_dimen where ‘Order Priority’ is high.
SELECT 
    Order_ID, Order_Date
FROM
    superstores.orders_dimen
WHERE
    Order_Priority = 'HIGH';
-- 4.Find the total and the average sales (display total_sales and avg_sales)
SELECT 
    ROUND(SUM(sales), 4) AS total_sales,
    ROUND(AVG(sales), 4) AS avg_sales
FROM
    superstores.market_fact;
-- 5.Write a query to get the maximum and minimum sales from maket_fact table.
SELECT 
    MAX(sales) AS 'Maximum_sales', MIN(sales) AS 'Minimum_sales'
FROM
    superstores.market_fact;
-- 6.Display the number of customers in each region in decreasing order of no_of_customers. The result should contain columns Region, no_of_customers.
SELECT 
    region, COUNT(Cust_id) no_of_customers
FROM
    superstores.cust_dimen
GROUP BY region
ORDER BY no_of_customers DESC;
-- 7.Find the region having maximum customers (display the region name and max(no_of_customers)
SELECT 
    region, (COUNT(Cust_id)) 'max_no_of_customers'
FROM
    superstores.cust_dimen
GROUP BY region
ORDER BY max_no_of_customers DESC
LIMIT 1;
-- 8.Find all the customers from Atlantic region who have ever purchased ‘TABLES’ and the number of tables purchased (display the customer name, no_of_tables purchased)
SELECT 
    CD.Customer_name, COUNT(*) number_of_tables_purchased
FROM
    superstores.market_fact AS MF
        JOIN
    superstores.cust_dimen AS CD ON MF.cust_id = CD.cust_id
WHERE
    CD.Region = 'Atlantic'
        AND MF.Prod_id = (SELECT 
            prod_id
        FROM
            superstores.prod_dimen
        WHERE
            product_sub_category = 'tables')
GROUP BY MF.Cust_id , CD.Customer_Name;
-- 9.Find all the customers from Ontario province who own Small Business. (display the customer name, no of small business owners)
SELECT 
    customer_name, COUNT(Customer_Name)
FROM
    superstores.cust_dimen
WHERE
    Province = 'Ontario'
        AND Customer_Segment = 'SMALL BUSINESS';
-- 10.Find the number and id of products sold in decreasing order of products sold (display product id, no_of_products sold)
SELECT 
    Prod_id AS product_id, COUNT(*) AS no_of_products_sold
FROM
    superstores.market_fact
GROUP BY Prod_id
ORDER BY no_of_products_sold DESC;
-- 11.Display product Id and product sub category whose produt category belongs to Furniture and Technlogy. The result should contain columns product id, product sub category.
SELECT 
    prod_id AS product_id,
    Product_Sub_Category AS product_Sub_category
FROM
    superstores.prod_dimen
WHERE
    Product_Category = 'FURNITURE'
        AND product_category = 'TECHNOLOGY';
-- 12.Display the product categories in descending order of profits (display the product category wise profits i.e. product_category, profits)?
SELECT 
    PD.Product_Category, SUM(MF.Profit) AS profits
FROM
    superstores.prod_dimen AS PD
        JOIN
    superstores.market_fact AS MF ON PD.prod_id = MF.prod_id
GROUP BY PD.Product_Category
ORDER BY Profits DESC;
-- 13.Display the product category, product sub-category and the profit within each subcategory in three columns. 
SELECT 
    PD.product_category, PD.Product_Sub_Category, SUM(MF.Profit)
FROM
    superstores.prod_dimen AS PD
        JOIN
    superstores.market_fact AS MF ON PD.prod_id = MF.prod_id
GROUP BY PD.Product_Category , PD.Product_Sub_Category;
-- 14.Display the order date, order quantity and the sales for the order.
SELECT 
    OD.Ord_id,
    OD.order_date,
    MF.Order_Quantity,
    SUM(MF.Sales) AS sales
FROM
    superstores.orders_dimen AS OD
        JOIN
    superstores.market_fact AS MF ON OD.ord_id = MF.ord_id
GROUP BY OD.ord_id;
-- 15. Display the names of the customers whose name contains the i) Second letter as ‘R’ ii) Fourth letter as ‘D’
SELECT 
    *
FROM
    superstores.cust_dimen
WHERE
    SUBSTR(customer_name, 2, 1) = 'R'
        AND SUBSTR(customer_name, 4, 1) = 'D';
-- 16.Write a SQL query to to make a list with Cust_Id, Sales, Customer Name and their region where sales are between 1000 and 5000.
SELECT 
    CD.Cust_id, sum(MF.Sales), CD.Customer_Name, CD.Region
FROM
    superstores.cust_dimen AS CD
        JOIN
    superstores.market_fact AS MF ON CD.Cust_id = MF.Cust_id
WHERE
    sales BETWEEN 1000 AND 5000
group by cust_id;
-- 17.Write a SQL query to find the 3rd highest sales.
SELECT 
    *
FROM
    superstores.market_fact
ORDER BY sales DESC
LIMIT 1 OFFSET 2;
-- 18.Where is the least profitable product subcategory shipped the most? For the least profitable product sub-category, display the region-wise no_of_shipments and the 
-- profit made in each region in decreasing order of profits (i.e. region, no_of_shipments, profit_in_each_region) 
-- → Note: You can hardcode the name of the least profitable product subcategory
SELECT 
    c.region,
    COUNT(DISTINCT s.ship_id) AS no_of_shipments,
    SUM(m.profit) AS profit_in_each_region
FROM
    superstores.market_fact m
        INNER JOIN
    superstores.cust_dimen c ON m.cust_id = c.cust_id
        INNER JOIN
    superstores.shipping_dimen s ON m.ship_id = s.ship_id
        INNER JOIN
    superstores.prod_dimen p ON m.prod_id = p.prod_id
WHERE
    p.product_sub_category IN (SELECT 
            p.product_sub_category
        FROM
            superstores.market_fact m
                INNER JOIN
            superstores.prod_dimen p ON m.prod_id = p.prod_id
        GROUP BY p.product_sub_category
        HAVING SUM(m.profit) <= ALL (SELECT 
                SUM(m.profit) AS profits
            FROM
                superstores.market_fact m
                    INNER JOIN
                superstores.prod_dimen p ON m.prod_id = p.prod_id
            GROUP BY p.product_sub_category))
GROUP BY c.region
ORDER BY profit_in_each_region DESC;