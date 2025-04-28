-- Глобальный индекс на customer_id
CREATE INDEX idx_orders_customer_id ON orders (customer_id);

-- Запрос с глобальным индексом
EXPLAIN ANALYZE
SELECT * FROM orders
WHERE customer_id = 1;