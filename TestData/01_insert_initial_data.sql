INSERT INTO countries (name, code) VALUES
                                       ('United States', 'US'),
                                       ('Eurozone', 'EU'),
                                       ('United Kingdom', 'GB'),
                                       ('Japan', 'JP')
    ON CONFLICT (code) DO NOTHING;

INSERT INTO banks (name, country_id) VALUES
                             ('Bank of America', (SELECT id FROM countries WHERE code = 'US')),
                             ('European Central Bank', (SELECT id FROM countries WHERE code = 'EU')),
                             ('Bank of England', (SELECT id FROM countries WHERE code = 'GB')),
                             ('Bank of Japan', (SELECT id FROM countries WHERE code = 'JP'))
    ON CONFLICT (name, country_id) DO NOTHING;

INSERT INTO currencies (code, name, country_id) VALUES
                                                    ('USD', 'United States Dollar', (SELECT id FROM countries WHERE code = 'US')),
                                                    ('EUR', 'Euro', (SELECT id FROM countries WHERE code = 'EU')),
                                                    ('GBP', 'British Pound', (SELECT id FROM countries WHERE code = 'GB')),
                                                    ('JPY', 'Japanese Yen', (SELECT id FROM countries WHERE code = 'JP'))
    ON CONFLICT (code) DO NOTHING;

INSERT INTO exchange_rates (currency_id, exchange_currency_id, rate, amount, exchange_date, bank_id, source, buy_rate, sell_rate) VALUES
                                                                                                                  ((SELECT id FROM currencies WHERE code = 'USD'), (SELECT id FROM currencies WHERE code = 'EUR'), 0.9200, 1, CURRENT_DATE, (SELECT id FROM banks WHERE name = 'Bank of America'), 'Official Source', 0.9200, 0.9200),
                                                                                                                  ((SELECT id FROM currencies WHERE code = 'EUR'), (SELECT id FROM currencies WHERE code = 'GBP'), 0.8100, 1, CURRENT_DATE, (SELECT id FROM banks WHERE name = 'European Central Bank'), 'Official Source', 0.8100, 0.8100),
                                                                                                                  ((SELECT id FROM currencies WHERE code = 'GBP'), (SELECT id FROM currencies WHERE code = 'JPY'), 110.5000, 1, CURRENT_DATE, (SELECT id FROM banks WHERE name = 'Bank of England'), 'Official Source', 110.5000, 110.5000),
                                                                                                                  ((SELECT id FROM currencies WHERE code = 'JPY'), (SELECT id FROM currencies WHERE code = 'USD'), 0.0090, 1, CURRENT_DATE, (SELECT id FROM banks WHERE name = 'Bank of Japan'), 'Official Source', 0.0090, 0.0090)
    ON CONFLICT DO NOTHING;

INSERT INTO exchange_rates (currency_id, exchange_currency_id, rate, amount, exchange_date, bank_id, source, buy_rate, sell_rate)
VALUES
    ((SELECT id FROM currencies WHERE code = 'USD'), (SELECT id FROM currencies WHERE code = 'GBP'), 0.75, 1, CURRENT_DATE, (SELECT id FROM banks WHERE name = 'Bank of America'), 'Market Data', 0.9200, 0.9200 ),
    ((SELECT id FROM currencies WHERE code = 'EUR'), (SELECT id FROM currencies WHERE code = 'JPY'), 130.5000, 1, CURRENT_DATE, (SELECT id FROM banks WHERE name = 'European Central Bank'), 'Market Data', 0.8100, 0.8100),
    ((SELECT id FROM currencies WHERE code = 'JPY'), (SELECT id FROM currencies WHERE code = 'GBP'), 0.0068, 1, CURRENT_DATE, (SELECT id FROM banks WHERE name = 'Bank of Japan'), 'Market Data', 110.5000, 110.5000),
    ((SELECT id FROM currencies WHERE code = 'GBP'), (SELECT id FROM currencies WHERE code = 'USD'), 1.33, 1, CURRENT_DATE, (SELECT id FROM banks WHERE name = 'Bank of England'), 'Market Data', 0.0090, 0.0090);

DO $$
DECLARE i INT := 1;
BEGIN
    WHILE i <= 96 LOOP
        INSERT INTO exchange_rates (currency_id, exchange_currency_id, rate, amount, exchange_date, bank_id, source, buy_rate, sell_rate)
        VALUES (
            (SELECT id FROM currencies ORDER BY RANDOM() LIMIT 1),
            (SELECT id FROM currencies ORDER BY RANDOM() LIMIT 1),
            ROUND(CAST(RANDOM() * (1.5 - 0.5) + 0.5 AS NUMERIC), 4),
            1,
            CURRENT_DATE - (i % 30),
            COALESCE((SELECT id FROM banks ORDER BY RANDOM() LIMIT 1), 1),
            'Generated Data',
            ROUND(CAST(RANDOM() * (1.5 - 0.5) + 0.5 AS NUMERIC), 4),
            ROUND(CAST(RANDOM() * (1.5 - 0.5) + 0.5 AS NUMERIC), 4)
        );
        i := i + 1;
END LOOP;
END $$;