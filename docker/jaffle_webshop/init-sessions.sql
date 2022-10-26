CREATE TABLE sessions(
  cookie_id VARCHAR NOT NULL,
  started_ts BIGINT NOT NULL,
  customer_id INT);

COPY sessions (cookie_id, started_ts, customer_id) from '/home/dump/raw_sessions.csv' delimiter ','  csv header;
