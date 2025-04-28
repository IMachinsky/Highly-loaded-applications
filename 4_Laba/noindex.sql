-- Удаление глобальных индексов
DROP INDEX IF EXISTS idx_orders_customer_id;
DROP INDEX IF EXISTS idx_orders_order_date;

-- Удаление локальных индексов
DROP INDEX IF EXISTS idx_orders_2023_q1_customer_id;
DROP INDEX IF EXISTS idx_orders_2023_q2_order_date;

-- Запрос без индексов
EXPLAIN ANALYZE
SELECT * FROM orders
WHERE customer_id = 1;