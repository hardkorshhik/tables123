CREATE TABLE IF NOT EXISTS currencies (
    id SERIAL PRIMARY KEY,
    code VARCHAR(3) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS exchange_rates (
    id SERIAL PRIMARY KEY,
    currency_id INTEGER NOT NULL,
    rate NUMERIC(10, 4) NOT NULL,
    effective_date DATE NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_currency
        FOREIGN KEY(currency_id)
            REFERENCES currencies(id)
);

CREATE INDEX IF NOT EXISTS idx_exchange_rates_effective_date 
    ON exchange_rates(effective_date);

CREATE INDEX IF NOT EXISTS idx_exchange_rates_currency_id 
    ON exchange_rates(currency_id);

INSERT INTO currencies (code, name)
VALUES 
    ('USD', 'United States Dollar'),
    ('EUR', 'Euro'),
    ('GBP', 'British Pound'),
    ('JPY', 'Japanese Yen')
ON CONFLICT (code) DO NOTHING;

INSERT INTO exchange_rates (currency_id, rate, effective_date)
VALUES
    ((SELECT id FROM currencies WHERE code = 'USD'), 1.0000, CURRENT_DATE),
    ((SELECT id FROM currencies WHERE code = 'EUR'), 0.9200, CURRENT_DATE),
    ((SELECT id FROM currencies WHERE code = 'GBP'), 0.8100, CURRENT_DATE),
    ((SELECT id FROM currencies WHERE code = 'JPY'), 110.5000, CURRENT_DATE);

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_exchange_rates_updated_at ON exchange_rates;

CREATE TRIGGER trg_update_exchange_rates_updated_at
BEFORE UPDATE ON exchange_rates
FOR EACH ROW
EXECUTE PROCEDURE update_updated_at_column();

SELECT
    er.id,
    c.code,
    er.rate,
    er.effective_date,
    er.updated_at
FROM exchange_rates er
JOIN currencies c ON er.currency_id = c.id
ORDER BY er.effective_date DESC;
