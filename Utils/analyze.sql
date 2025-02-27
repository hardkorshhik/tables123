-- Анализ получения на конкретную дату
EXPLAIN ANALYZE
SELECT *
FROM vw_exchange_rates_by_date
WHERE exchange_date = '2025-02-23';

-- Анализ получения минимальных и максимальных значений
EXPLAIN ANALYZE
SELECT
    er.currency_id,
    MIN(er.rate) AS min_rate,
    MAX(er.rate) AS max_rate
FROM exchange_rates er
WHERE er.currency_id = (SELECT id FROM currencies WHERE code = 'USD')
  AND er.exchange_date BETWEEN '2025-02-01' AND '2025-02-23'
GROUP BY er.currency_id;