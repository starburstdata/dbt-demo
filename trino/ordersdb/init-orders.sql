CREATE TABLE orders(
	id INT PRIMARY KEY,
	user_id INT NOT NULL,
	order_date date NOT NULL,
	status VARCHAR(255) NOT NULL);
	
COPY orders (id, user_id, order_date, status) from '/home/dump/raw_orders.csv' delimiter ','  csv header;
