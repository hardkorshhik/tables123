CREATE TABLE IF NOT EXISTS countries (
                                         id SERIAL PRIMARY KEY,
                                         name VARCHAR(100) NOT NULL UNIQUE,
    code VARCHAR(3) NOT NULL UNIQUE
    );

CREATE TABLE IF NOT EXISTS banks (
                                     id SERIAL PRIMARY KEY,
                                     name VARCHAR(100) NOT NULL UNIQUE
    );

CREATE TABLE IF NOT EXISTS currencies (
                                          id SERIAL PRIMARY KEY,
                                          code VARCHAR(3) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    country_id INTEGER NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_country FOREIGN KEY(country_id) REFERENCES countries(id)
    );

CREATE TABLE IF NOT EXISTS exchange_rates (
                                              id SERIAL PRIMARY KEY,
                                              currency_id INTEGER NOT NULL,
                                              exchange_currency_id INTEGER NOT NULL,
                                              rate NUMERIC(10, 4) NOT NULL,
    amount NUMERIC(10, 2) NOT NULL DEFAULT 1,
    effective_date DATE NOT NULL,
    bank_id INTEGER NOT NULL,
    source VARCHAR(50),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_currency FOREIGN KEY(currency_id) REFERENCES currencies(id),
    CONSTRAINT fk_exchange_currency FOREIGN KEY(exchange_currency_id) REFERENCES currencies(id),
    CONSTRAINT fk_bank FOREIGN KEY(bank_id) REFERENCES banks(id)
    );

CREATE INDEX IF NOT EXISTS idx_exchange_rates_effective_date
    ON exchange_rates(effective_date);

CREATE INDEX IF NOT EXISTS idx_exchange_rates_currency_id
    ON exchange_rates(currency_id);

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

COMMENT ON COLUMN exchange_rates.source IS 'Источник данных для курса валют';
COMMENT ON COLUMN exchange_rates.amount IS 'Количество базовой валюты';