-- Удаление глобального индекса
DROP INDEX IF EXISTS idx_orders_customer_id;

-- Локальный индекс на customer_id для первой партиции
CREATE INDEX idx_orders_2023_q1_customer_id ON orders_2023_q1 (customer_id);

-- Запрос с локальным индексом
EXPLAIN ANALYZE
SELECT * FROM orders_2023_q1
WHERE customer_id = 1;