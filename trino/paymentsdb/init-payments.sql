CREATE TABLE payments(
	id INT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_method VARCHAR(128) NOT NULL,
    amount INT);
	
COPY payments (id, order_id, payment_method, amount) from '/home/dump/raw_payments.csv' delimiter ','  csv header;
