/* NorthWind의 카테고리별 매출액 비중 */
SELECT prd.category, prd.standard_cost, odd.quantity * odd.unit_price AS total_price
FROM products AS prd
LEFT JOIN order_details AS odd
    ON odd.product_id = prd.id;

/* 각 카테고리별 평균 표준원가 */
SELECT avg(prd.standard_cost) AS Average_standardcost
FROM products AS prd; /* 모든 product의 평균 표준원가 */
SELECT prd.category, avg(prd.standard_cost) AS Average_standard_cost
FROM products AS prd
GROUP BY prd.category;

/* Beverages 매출 비중을 차지하는 고객(회사) */
SELECT ord.order_date, ord.shipping_fee, ct.company, pror.category, pror.total_price
FROM orders AS ord
LEFT JOIN customers AS ct ON ord.customer_id = ct.id
LEFT JOIN (SELECT odd.order_id, prd.category, prd.standard_cost, odd.quantity * odd.unit_price AS total_price
            FROM products AS prd
            LEFT JOIN order_details AS odd
                ON odd.product_id = prd.id) AS pror ON pror.order_id = ord.id
WHERE pror.category = "Beverages";

/* 전체 매출액 대비 회사별 매출액 비중 */
SELECT ord.order_date, ord.shipping_fee, ct.company, pror.category, pror.total_price
FROM orders AS ord
LEFT JOIN customers AS ct ON ord.customer_id = ct.id
LEFT JOIN (SELECT odd.order_id, prd.category, prd.standard_cost, odd.quantity * odd.unit_price AS total_price
            FROM products AS prd
            LEFT JOIN order_details AS odd
                ON odd.product_id = prd.id) AS pror ON pror.order_id = ord.id;

/* 구매 TOP3 회사의 날짜별 총 구매액 */
SELECT ord.order_date, ord.shipping_fee, ct.company,
          pror.category, pror.total_price
FROM orders AS ord
LEFT JOIN customers AS ct ON ord.customer_id = ct.id
LEFT JOIN (SELECT odd.order_id, prd.category, prd.standard_cost,
                odd.quantity * odd.unit_price AS total_price
            FROM products AS prd
            LEFT JOIN order_details AS odd
                ON odd.product_id = prd.id) AS pror
    ON pror.order_id = ord.id
WHERE ct.company in ('Company BB', 'Company G', 'Company F');
