CREATE OR REPLACE VIEW vw_min_max_rate AS
    SELECT
        er.currency_id,
        er.exchange_date,
        cur.id,
        MIN(er.rate) AS min_rate,
        MAX(er.rate) AS max_rate
    FROM exchange_rates er
    JOIN currencies cur ON er.currency_id = cur.id
    GROUP BY er.currency_id, er.exchange_date,cur.id;

CREATE OR REPLACE VIEW vw_exchange_rates_by_date AS
    SELECT
        er.currency_id,
        cur.code AS currency_code,
        er.exchange_currency_id,
        cur2.code AS exchange_currency_code,
        er.rate,
        er.buy_rate,
        er.sell_rate,
        er.exchange_date,
        er.bank_id,
        b.name AS bank_name
    FROM exchange_rates er
    JOIN currencies cur ON er.currency_id = cur.id
    JOIN currencies cur2 ON er.exchange_currency_id = cur2.id
    JOIN banks b ON er.bank_id = b.id;