create table Salesman
(
salesman_id  int,
name        varchar(20),
city        varchar(20),
commission decimal(4,2)
)
insert into salesman
values
(5001,         'James Hoog',  'New York',    0.15),
(5002 ,        'Nail Knite',  'Paris',       0.13),
(5005  ,       'Pit Alex',  'London',      0.11),
(5006   ,      'Mc Lyon',  'Paris',       0.14),
(5003    ,     'Lauson Hen',null,        0.12),
(5007     ,    'Paul Adam',  'Rome',        0.13)
select * from salesman

------------------------------------
create table orders
(
ord_no      int,
purch_amt   decimal (10,3),
ord_date    date,
customer_id  int,
salesman_id int
)
insert into orders
values

(70001 ,      150.5,       '2012-10-05',  3005,         5002),
(70009  ,     270.65,      '2012-09-10',  3001 ,        5005),
(70002   ,    65.26  ,     '2012-10-05',  3002  ,       5001),
(70004    ,   110.5   ,    '2012-08-17',  3009   ,      5003),
(70007     ,  948.5    ,   '2012-09-10',  3005    ,     5002),
(70005      , 2400.6    ,  '2012-07-27',  3007     ,    5001),
(70008 ,      5760       , '2012-09-10',  3002      ,   5001),
(70010  ,     1983.43,     '2012-10-10',  3004       ,  5006),
(70003   ,    2480.4  ,    '2012-10-10',  3009        , 5003),
(70012    ,   250.45   ,   '2012-06-27',  3008         ,5002),
(70011     ,  75.29     ,  '2012-08-17',  3003     ,    5007),
(70013      , 3045.6     , '2012-04-25',  3002      ,   5001)

select * from orders

create table customer
(
customer_id  int,
cust_name varchar(20),
city    varchar(20),
grade   int,
salesman_id int
)

insert into customer
values
(3002,         'Nick Rimando','New York'  ,  100 ,        5001),
(3005 ,        'Graham Zusi','California' , 200  ,       5002),
(3001  ,       'Brad Guzan','London', null,           5005),
(3004   ,      'Fabian Johns','Paris'     ,  300 ,        5006),
(3007    ,     'Brad Davis','New York'    ,200   ,      5001),
(3009     ,    'Geoff Camero','Berlin'    ,  100 ,        5003),
(3008      ,   'Julian Green','London'    ,  300 ,        5002),
(3003       ,  'Jozy Altidor','Moscow'    ,  200 ,        5007)
---------------------------------------------------------------------------------------

-- 1 --
select  s.salesman_id,
        salesman_name = s.name,
        c.customer_id,
        c.cust_name,
        num_of_orders = count(*) 
from    salesman s
        join customer c on s.salesman_id = c.salesman_id
        join orders o on c.customer_id = o.customer_id
group   by s.salesman_id,
        s.name,
        c.customer_id,
        c.cust_name
having  count(*)>1;

-- 2 -- 

select  count(*)
from    customer
where   grade >(select  avg(grade) 
                from    customer
                where   city = 'New York' )

-- 3 --

select  s.salesman_id,
        salesman_name = s.name,
        num_of_cust = count(*)
from    salesman s
        join customer c on s.salesman_id = c.salesman_id    
group   by s.salesman_id,
        s.name
having  count(*)>1

-- 4 --

select  o.ord_no,
        o.purch_amt,
        o.customer_id
from    orders o join ( select  customer_id,
                                avg_ord_amt = avg(purch_amt) 
                        from    orders
                        group by customer_id )a 
                        on o.customer_id = a.customer_id
where   o.purch_amt > a.avg_ord_amt

------------------------------------------------------------------------------------