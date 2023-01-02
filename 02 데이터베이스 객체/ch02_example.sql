-- self check

-- 1. 다음과 같은 구조의 테이블을 생성해보자.
create table ORDERS (
            ORDER_ID NUMBER(12,0) PRIMARY KEY,
            ORDER_MODE VARCHAR2(8 BYTE)
                CONSTRAINT CK_ORDER_MODE CHECK (ORDER_MODE IN ('direct', 'online')),
            ORDER_DATE DATE,
            CUSTOMER_ID NUMBER(6,0),
            ORDER_STATUS NUMBER(2,0),
            ORDER_TOTAL NUMBER(8,2) DEFAULT 0,
            SALES_REP_ID NUMBER(6,0),
            PROMOTION_ID NUMBER(6,0)
            );
            
drop table orders;
--commit;

-- 2. 다음과 같은 구조의 테이블을 생성해보자.
create table ORDER_ITEMS (
            ORDER_ID NUMBER(12,0),
            LINE_ITEM_ID NUMBER(3,0),
            PRODUCT_ID NUMBER(3,0),
            UNIT_PRICE NUMBER(8,2) DEFAULT 0,
            QUANTITY NUMBER(8,0) DEFAULT 0,
            CONSTRAINT PRIMARY_KEY PRIMARY KEY (ORDER_ID, LINE_ITEM_ID)
            );
            
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME, A.*
    FROM ALL_CONSTRAINTS A
    WHERE TABLE_NAME = 'ORDER_ITEMS';
    
SELECT *
    FROM ALL_CONS_COLUMNS
    WHERE CONSTRAINT_NAME = 'PRIMARY_KEY';
    
-- 3. 다음과 같은 구조의 테이블을 생성해보자.
create table PROMOTIONS (
            PROMO_ID NUMBER(6,0) PRIMARY KEY,
            PROMO_NAME VARCHAR2(20)
            );
            
-- 4.
-- 5. 최솟값 1, 최대값 99999999, 1000부터 시작해서 1씩 증가하는 ORDERS_SEQ라는 시퀀스를 만들어보자.
create sequence ORDERS_SEQ
    increment by 1
    start with 1000
    minvalue 1
    maxvalue 99999999
    nocycle
    nocache;

