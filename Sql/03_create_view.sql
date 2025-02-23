CREATE OR REPLACE VIEW vw_min_max_rate AS
    SELECT
        currency_id,
        MIN(rate) AS min_rate,
        MAX(rate) AS max_rate
    FROM exchange_rates
    GROUP BY currency_id;

CREATE OR REPLACE VIEW vw_exchange_rates_by_date AS
    SELECT
        er.currency_id,
        cur.code AS currency_code,
        er.exchange_currency_id,
        cur2.code AS exchange_currency_code,
        er.rate,
        er.buy_rate,
        er.sell_rate,
        er.effective_date,
        er.bank_id,
        b.name AS bank_name
    FROM exchange_rates er
    JOIN currencies cur ON er.currency_id = cur.id
    JOIN currencies cur2 ON er.exchange_currency_id = cur2.id
    JOIN banks b ON er.bank_id = b.id;

-- Анализ получения на конкретную дату
EXPLAIN ANALYZE
SELECT *
FROM vw_exchange_rates_by_date
WHERE effective_date = '2025-02-23'

-- Анализ получения минимальных и максимальных значений
EXPLAIN ANALYZE
SELECT
    er.currency_id,
    MIN(er.rate) AS min_rate,
    MAX(er.rate) AS max_rate
FROM exchange_rates er
WHERE er.currency_id = (SELECT id FROM currencies WHERE code = 'USD')
    AND er.effective_date BETWEEN '2025-02-01' AND '2025-02-23'
GROUP BY er.currency_id;
