-- 
-- Create some employees
-- 
INSERT INTO employees (
    first_name,
    last_name,
    job_title,
    email,
    birthday,
    pin_code,
    phone
) VALUES 
('Sally','Sellers','Sales Person','sally@company.com','1980-07-05',1234,9785554433),
('Vick','Vendors','Sales Person','Tom@company.com','1978-05-03',0000,9785554434),
('Bob','Builders','Mechanic','bob@company.com','1982-03-01',9876,9785554435),
('Tammy','Tinkers','Mechanic','tam@company.com','1987-02-01',4444,9785554436);


-- Add some cars to inventory using function
SELECT add_car_to_inventory('VEG6M57G5S44FW87X','Dodge','Caravan',2013::smallint,true,'$10000');
SELECT add_car_to_inventory('NCD1FW9U5M8CK4Y14','Hyundai','Ioniq',2017::smallint,true,'$15000');
SELECT add_car_to_inventory('4MXJYF2LTVGF4UT88','Chevrolet','Metro',2021::smallint,false,'$20000');
SELECT add_car_to_inventory('E87JU5DWEWLEER1NN','Ford','Five Hundred',2022::smallint,false,'$40000');
SELECT add_car_to_inventory('YFD3LTH88FCMUJHYL','Honda','Pilot',2022::smallint,false,'$50000');
SELECT add_car_to_inventory('C5N28DHJ2FCVDE7D6','Acura','Legend',2023::smallint,false,'$23000');
SELECT add_car_to_inventory('BVSECT8M6F6SL9TP3','Ford','Edge',2017::smallint,true,'$28000');
SELECT add_car_to_inventory('HXWK5DJC8LBKJ4N78','Nissan','Frontier',2018::smallint,true,'$19000');
SELECT add_car_to_inventory('FUDS1W9LFYK26WP97','Lexus','CT',2019::smallint,true,'$34000');
SELECT add_car_to_inventory('6KXMMWL9PHFFSA12M','Mitsubishi','Outlander',2003::smallint,true,'$5000');
SELECT add_car_to_inventory('AH9HSGD8APV7DL4T8','Chevrolet','Avalanche',2020::smallint,true,'$19000');


-- Simultaniously sell create customer, sell cars, and create invoice
-- using combination of procedure and function
CALL purchase_car_new_customer(1,'$20000','VEG6M57G5S44FW87X','Conor','Fenderman',9775553223,'conor@email.com');
CALL purchase_car_new_customer(2,'$30000','NCD1FW9U5M8CK4Y14','Jenna','Apollo',9775552222,'jenna@email.com');
CALL purchase_car_new_customer(1,'$42000','4MXJYF2LTVGF4UT88','Christa','Alson',9775553333,'christa@email.com');
CALL purchase_car_new_customer(2,'$63000','E87JU5DWEWLEER1NN','Noah','Freckleson',9775557777,'noah@email.com');

-- 
-- Add a new customer that goes in for services. Worked on by Bob Builders and Tammy Tinkers. Bob wrote the invoice.
-- 

-- Add Andrew into customer table
INSERT INTO customers (first_name,last_name,phone,email)
VALUES ('Andrew','Clifford',9785551236,'andrewemail@email.com');

-- Find Andrew's customer ID (6 for me)
SELECT customer_id FROM customers WHERE first_name = 'Andrew';

-- Adding Andrew's car
INSERT INTO cars (vin_num,make,model,model_year,for_sale,customer_id)
VALUES('HDXPYS2X5JXE54PN6','Chevrolet','Tahoe',2018,false,6);

-- Find Bob's employee_id (3 for me) (Note Tammy's for later (4))
SELECT employee_id, first_name FROM employees;

-- Create Invoice
INSERT INTO invoices (customer_id,employee_id,vin_num,amount,car_sale)
VALUES(6,3,'HDXPYS2X5JXE54PN6','$200',false);

-- Find invoice ID (invoice id 6 for me)
SELECT invoice_id FROM invoices WHERE vin_num = 'HDXPYS2X5JXE54PN6';

-- Add Service Ticket
INSERT INTO service_tickets(service_done,invoice_id,vin_num,date_start,date_end)
VALUES ('oil change',6,'HDXPYS2X5JXE54PN6','2023-04-09','2023-04-09');

-- Lookup service ticket number (1 for me)
SELECT service_id FROM service_tickets WHERE vin_num = 'HDXPYS2X5JXE54PN6';

-- Add record that tammy (id=4) and bob (id=3) works on this service (id=1)
INSERT INTO service_done_by (service_id,employee_id)
VALUES (1,3),(1,4);


-- 
-- Add service done on existing customer Conor's car by just tammy
-- 

-- Get Conor's ID (id=1)
SELECT * FROM customers WHERE first_name = 'Conor';

-- Insert invoice
-- Tammy's id (4) was already known. Conor's car was known from when input
INSERT INTO invoices (customer_id,employee_id,vin_num,amount,car_sale)
VALUES(1,4,'VEG6M57G5S44FW87X','$100',false);

-- Find invoice id (7) 
SELECT invoice_id FROM invoices WHERE vin_num = 'VEG6M57G5S44FW87X' AND amount = '$100';

-- Create service ticket
INSERT INTO service_tickets(service_done,invoice_id,vin_num,date_start,date_end)
VALUES ('replaced wiper fluid',7,'VEG6M57G5S44FW87X','2023-04-09','2023-04-09');

-- Lookup service ticket number (2 for me)
SELECT service_id FROM service_tickets WHERE vin_num = 'VEG6M57G5S44FW87X';

-- Mark tammy (4) down as having worked on the service
INSERT INTO service_done_by (service_id,employee_id)
VALUES (2,4);