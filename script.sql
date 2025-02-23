DO $$
DECLARE
    i INT := 1;
BEGIN
    WHILE i <= 100000 LOOP
        INSERT INTO exchange_rates (currency_id, exchange_currency_id, rate, amount, effective_date, bank_id, source, buy_rate, sell_rate)
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