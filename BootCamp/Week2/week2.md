### 2주차

ERD를 사용해 DB의 데이터를 파악

대부분은 데이터를 잘 파악하고 분석에 활용하는 능력이 중요



#### Redash : 쿼리 브라우져 (ex. )

1. 기능
   - Dashboards, Queries
   - Format Queries, 쿼리 좌측 두번째 아이콘
     - 쿼리 양식을 이쁘게 세팅해주는 기능, 한줄을 띄워주거나 함수를 대분자로 바꾸어줌
   - Visualization 기능을 사용, Chart를 그릴 수 있음
2. 시각화 기능이 강력
3. 기본적으로 무료
4. 다른 쿼리브라우저를 사용하더라도 UI가 비슷할 것

Table을 불러올 때는 limit를 주는 습관이 중요

- 데이터가 많으면 소요가 크기 때문



### 문제

#### 출제의도

1. 그룹바이 사용 원하는 숫자 구할 수 있는가?

   - as 생략 가능
   - from부터 아래로 ORDER BY전까지 읽고 select부분을 읽음
   - count 안에 열이름이 들어간다면, NULL을 생략하고 카운트함
   - 순서 바뀐걸 제외하고는 잘 작성

2. 여러 테이블을 Join 하는 것, 날짜 조건

   - 날짜 조건

   - ```mysql 
     SELECT order_date FROM orders LIMIT 5;
     ```

   - 2006년 1분기 조건을 어떻게 걸 것인가?

     1. SUBSTR(order_date, 1, 7) : 2006-01

        ```mysql
        substr(order_date, 1, 7) in ('2006-01', '2006-02', '2006-03')
        ```

     2. DATE_FORMAT(order_date, '%Y-%m') : 2006-01

        DATE_FORMAT(order_date, '%y-%m') : 06-01

        ```mysql
        date_format(order_date, '%Y-%m') in ('2006-01', '2006-02', '2006-03')
        ```

     3. BETWEEN : 양쪽이 모두 포함

        ```mysql
        WHERE order_date BETWEEN '2006-01-01' AND '2006-03-31'
        WHERE order_date BETWEEN '2006-01-01' AND '2006-03-31 23:59:59'
        ```

        시분초가 기본값인 경우엔 상관이 없지만 실제론 '2006-03-31 00:00:00' 이다.

        따라서 3월 31일 00시 이후 데이터는 포함되지 않는다. 그래서 아래를 추천

     4. <= AND <

        ```mysql
        WHERE '2006-01-01' <= order_date
        	AND order_date < '2006-04-01'
        ```

     5. year() month() quarter()가능

        ```mysql
        WHERE YEAR(order_date) = 2006 AND MONTH(order_date) < 4
        WHERE YEAR(order_date) = 2006 AND QUARTER(order_date) = 1
        ```

   - **count 안에 distinct를 넣는다면 중복을 계산하지 않음**

     - 일대 다 관계에서 id가 여러개일 수 있으므로 id가 여러개일 수가 있다.

   - **GROUP BY 1,2 : SELECT에 있는 첫번째 두번째로 그룹바이 해주겠다.**

   - **Group by에 없는 행은 SELECT에 집계함수를 쓰지 않고 쓸 수 없다.**

   - 카테고리수를 셀 때 distict를 넣어서 작성

3. sub-query를 구현

   - 쿼리의 속도면에서는 Join이 유리하지만 sub-query를 연습 유도

     ```mysql
     SELECT id, status_id, (SELECT status_name FROM orders_status os where os.id = o.status_id)
     FROM orders o
     WHERE '2006-03-01' <= o.order_date
     	AND o.order_date < '2006-04-01'
     ```

   - 알리어스(AS) 로 작성하는 것이 더 보기 편함

4. having 문법 사용

   - Having을 사용하면 좀더 우아하게 만들 수 있음
     - **집계를 하고 난 뒤에 나온 결과를 조건을 걸 때 사용**
     - 굳이 서브쿼리를 걸어서 새로 WHERE을 걸 필요가 없음
     - GROUP BY가 없으면 HAVING이 있을 수가 없음
   - COUNT(*) >= 3을 HAVING에 걸고 분기에 대한 내용을 WHERE로 해주어야함
   - 또한 distinct를 걸어주어야 정확히 결과가 나옴

5. 교집합을 목적으로 inner join을 사용하여 해결

   - 5-1 : 1분기에 주문 받은 직원 ∩ 2분기에 주문받은 직원
   - 5-2에는 2분기에 받은 주문 수를 찾는 쿼리에 5-1을 더해준 것
   - 5-3 역시 연, 월 별로 카운트를 해주고 거기에 5-1을 합쳐주는 것
   - **스텝을 나눠서 합치는 것이 굉장히 좋음**
   - TAB을 활용하면  sub-query를 구분하기 좋음

SELECT FROM JOIN WHERE 순서임



### 3주차

>  굵은 글씨 순으로 따라서 해보는 것이 좋다. 분석 보고서 쓰는 법을 검색 해보면 좋을 것

