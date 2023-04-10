CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    phone NUMERIC(10) CHECK (phone > 0 AND phone < 10000000000),
    email VARCHAR(50),
    date_added TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE cars (
    vin_num CHAR(17) PRIMARY KEY,
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    model_year SMALLINT CHECK (model_year >= 1886),
    used BOOLEAN,
    base_cost MONEY,
    for_sale BOOLEAN NOT NULL,
    customer_id INTEGER,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    job_title VARCHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL,
    UNIQUE(email),
    birthday DATE NOT NULL,
    pin_code NUMERIC(4) NOT NULL CHECK (pin_code >= 0),
    phone NUMERIC CHECK (phone > 0 AND phone < 10000000000)
);


CREATE TABLE invoices (
    invoice_id SERIAL PRIMARY KEY,
    invoice_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    customer_id INTEGER NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    employee_id INTEGER NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    vin_num CHAR(17) NOT NULL,
    FOREIGN KEY (vin_num) REFERENCES cars(vin_num),
    amount MONEY NOT NULL,
    car_sale BOOLEAN NOT NULL
);

CREATE TABLE service_tickets (
    service_id SERIAL PRIMARY KEY,
    service_done VARCHAR(100),
    invoice_id INTEGER NOT NULL,
    FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id),
    vin_num CHAR(17) NOT NULL,
    FOREIGN KEY (vin_num) REFERENCES cars(vin_num),    
    date_start DATE NOT NULL DEFAULT CURRENT_DATE,
    date_end DATE
);

CREATE TABLE service_done_by (
    service_id INTEGER NOT NULL,
    FOREIGN KEY (service_id) REFERENCES service_tickets(service_id),
    employee_id INTEGER NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE OR REPLACE FUNCTION add_customer_get_id(
    f_name VARCHAR(20),
    l_name VARCHAR(20),
    their_phone NUMERIC(10),
    their_email VARCHAR(50)
    )
    RETURNS INT
    LANGUAGE plpgsql
    AS $MAIN$
    DECLARE
    _customer_id INTEGER;
    BEGIN
    INSERT INTO customers(first_name,last_name,phone,email)
    VALUES (f_name,l_name,their_phone,their_email)
    RETURNING customer_id INTO _customer_id;

    RETURN _customer_id;

    END
    $MAIN$
    ;

CREATE PROCEDURE purchase_car_new_customer (
    _employee_id INTEGER,
    _price MONEY,
    _vin_num CHAR(17),
    _customer_first_name VARCHAR(20),
    _customer_last_name VARCHAR(20),
    _phone NUMERIC(10),
    _email VARCHAR(50)
    )
    LANGUAGE plpgsql
    AS
    $$
    DECLARE
    _customer_id INTEGER;
    BEGIN
        SELECT add_customer_get_id(_customer_first_name,_customer_last_name,_phone,_email) INTO _customer_id;
        
        UPDATE cars
        SET for_sale = false
        WHERE vin_num = _vin_num;

        UPDATE cars
        SET customer_id = _customer_id
        WHERE vin_num = _vin_num;

        INSERT INTO invoices (
            customer_id,
            employee_id,
            vin_num,
            amount,
            car_sale
        ) VALUES (_customer_id,_employee_id,_vin_num,_price,true);
        
        COMMIT;

    END
    $$
    ;

CREATE OR REPLACE FUNCTION add_car_to_inventory(
    _vin_num CHAR(17),
    _make VARCHAR(50),
    _model VARCHAR(50),
    _model_year SMALLINT,
    _used BOOLEAN,
    _base_cost MONEY
    )
    RETURNS VOID
    LANGUAGE plpgsql
    AS
    $MAIN$
    BEGIN
    INSERT INTO cars (
    vin_num,
    make,
    model,
    model_year,
    used,
    base_cost,
    for_sale
    ) VALUES(_vin_num,_make,_model,_model_year,_used,_base_cost,true);
    END
    $MAIN$
    ;

