/* 1. 상품(product)의 카테고리(category)별로,
    상품 수와 평균 가격대(list_price)를 찾는 쿼리를 작성하세요. */
SELECT category, AVG(list_price) as avg_price, count(*) as count
FROM products
GROUP BY category;


/* 2. 2006년 1분기에 고객(customer)별 주문(order) 횟수, 주문한 상품(product)이ㅡ 카테고리(category) 수,
    총 주문 금액(quantity * unit_price)과 고객의 이름(last_name, first_name)을 찾는 쿼리를 작성하세요. */
SELECT cust.id, cust.last_name, cust.first_name,
        count(prd.category) AS 카테고리수,
        count(*) AS 주문횟수,
        SUM(ordd.quantity*ordd.unit_price) AS 총주문금액
FROM orders AS ord
LEFT JOIN customers AS cust
    ON ord.customer_id = cust.id
LEFT JOIN order_details AS ordd
    ON ord.id = ordd.order_id
LEFT JOIN products AS prd
    ON ordd.product_id = prd.id
WHERE DATE_FORMAT(ord.order_date,'%y') = '06'
    AND (DATE_FORMAT(ord.order_date,'%c') = '1'
    OR DATE_FORMAT(ord.order_date,'%c') = '2'
    OR DATE_FORMAT(ord.order_date,'%c') = '3')
GROUP BY cust.id;


/* 3. 2006년 3월에 주문(order)된 건의 주문 상태(status_name)를 찾는 쿼리를 작성하세요. */
SELECT *, (SELECT status_name FROM orders_status WHERE id = status_id) AS status
FROM orders WHERE DATE_FORMAT(order_date, '%y.%c') = '06.3';


/* 4. 2006년 1분기 동안 세 번 이상 주문(order)된 상품(product)와 그 상품의 주문 수를 찾는 쿼리를 작성하세요. */
SELECT ord.id, ordd.product_id, ord.order_date, count(ordd.product_id)
FROM order_details AS ordd
LEFT JOIN orders AS ord
    ON ord.id = ordd.product_id
GROUP BY ordd.product_id
HAVING DATE_FORMAT(ord.order_date, '%y%c') = '061'
    OR DATE_FORMAT(ord.order_date, '%y%c') = '062'
    OR DATE_FORMAT(ord.order_date, '%y%c') = '063';


/* 예시 답안 */
select category, count(1) cnt, avg(list_price) avg_price
from products
group by category;


select o.customer_id, 
    c.last_name, 
    c.first_name, 
    count(distinct o.id) order_cnt, 
    count(distinct p.category) category_cnt, 
    sum(od.quantity * od.unit_price) sum_of_order_price
from orders as o
    left join customers c on o.customer_id = c.id
    left join order_details od on o.id = od.order_id
    left join products p on od.product_id = p.id
where '2006-01-01' <= o.order_date
    and o.order_date < '2006-04-01'
group by o.customer_id, c.last_name, c.first_name;


select id, status_id, (select status_name from orders_status os where os.id = o.status_id) status_name
from orders o
where '2006-03-01' <= order_date 
    and order_date < '2006-04-01';


select product_id, count(distinct o.id) cnt
from orders o
    left join order_details od on o.id = od.order_id
where '2006-01-01' <= order_date 
    and order_date < '2006-04-01'
group by product_id
having count(distinct o.id) >= 3;


/* 5-1. 2006년 1분기, 2분기 연속으로 하나 이상의 주문(order)을 받은 직원(employee)을 찾는 쿼리를 작성하세요.
    (order_status는 신경쓰지 않으셔도 됩니다.) (힌트: sub-query, inner join)
    -- 1분기: 1,3,4,6,8,9
    -- 2분기: 1,2,3,4,6,7,8,9 */
select o1.employee_id
from 
    (select distinct employee_id
    from orders
    where '2006-01-01' <= order_date 
        and order_date < '2006-04-01') o1
        
    inner join
    
    (select distinct employee_id
    from orders
    where '2006-04-01' <= order_date 
        and order_date < '2006-07-01') o2
        
    on o1.employee_id = o2.employee_id;


/* 5-2. 2006년 1분기, 2분기 연속으로 하나 이상의 주문을 받은 직원별로,
    2006년 2분기 동안 받은 주문 수를 찾는 쿼리를 작성하세요.
    (order_status는 신경쓰지 않으셔도 됩니다.) (힌트: sub-query 중첩) */
select employee_id, count(1) cnt
from orders
where employee_id in (
    select o1.employee_id
        from 
            (select distinct employee_id
            from orders
            where '2006-01-01' <= order_date 
                and order_date < '2006-04-01') o1
            inner join
            (select distinct employee_id
            from orders
            where '2006-04-01' <= order_date 
                and order_date < '2006-07-01') o2
            on o1.employee_id = o2.employee_id
        )
    and '2006-04-01' <= order_date 
    and order_date < '2006-07-01'
group by employee_id;


/* 5-3. 2006년 1분기, 2분기 연속으로 하나 이상의 주문을 받은 직원별로, 월별 주문 수를 찾는 쿼리를 작성하세요.
    (order_status는 신경쓰지 않으셔도 됩니다.) (힌트: date_format() ) */
select employee_id, date_format(order_date, '%Y-%m') ym, count(1) cnt
from orders
where employee_id in (
    select o1.employee_id
        from 
            (select distinct employee_id
            from orders
            where '2006-01-01' <= order_date 
                and order_date < '2006-04-01') o1
            inner join
            (select distinct employee_id
            from orders
            where '2006-04-01' <= order_date 
                and order_date < '2006-07-01') o2
            on o1.employee_id = o2.employee_id
        )
    and '2006-01-01' <= order_date 
    and order_date < '2007-01-01'
group by 1, 2;
