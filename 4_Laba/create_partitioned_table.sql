-- Создание родительской таблицы
CREATE TABLE orders (
    order_id SERIAL,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    amount NUMERIC(10, 2),
    PRIMARY KEY (order_id, order_date) -- Добавляем order_date в первичный ключ
) PARTITION BY RANGE (order_date);

-- Создание партиций для разных периодов
CREATE TABLE orders_2023_q1 PARTITION OF orders
    FOR VALUES FROM ('2023-01-01') TO ('2023-04-01');

CREATE TABLE orders_2023_q2 PARTITION OF orders
    FOR VALUES FROM ('2023-04-01') TO ('2023-07-01');

CREATE TABLE orders_2023_q3 PARTITION OF orders
    FOR VALUES FROM ('2023-07-01') TO ('2023-10-01');

CREATE TABLE orders_2023_q4 PARTITION OF orders
    FOR VALUES FROM ('2023-10-01') TO ('2024-01-01');

-- Вставка данных в первый квартал 2023
INSERT INTO orders (customer_id, order_date, amount)
VALUES (1, '2023-01-15', 100.00);

-- Вставка данных во второй квартал 2023
INSERT INTO orders (customer_id, order_date, amount)
VALUES (2, '2023-05-20', 200.00);

-- Глобальный индекс на родительской таблице
CREATE INDEX idx_orders_order_date ON orders (order_date);

-- Локальный индекс на конкретной партиции
CREATE INDEX idx_orders_2023_q1_customer_id ON orders_2023_q1 (customer_id);

-- Добавление партиции для первого квартала 2024
CREATE TABLE orders_2024_q1 PARTITION OF orders
    FOR VALUES FROM ('2024-01-01') TO ('2024-04-01');

-- Удаление партиции
DROP TABLE orders_2023_q3;

-- Выборка данных за первый квартал 2023
EXPLAIN ANALYZE
SELECT * FROM orders
WHERE order_date BETWEEN '2023-01-01' AND '2023-04-01';

-- Выборка данных для конкретного клиента
EXPLAIN ANALYZE
SELECT * FROM orders
WHERE customer_id = 1;
