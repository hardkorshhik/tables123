CREATE INDEX IF NOT EXISTS idx_exchange_rates_exchange_date_currency
    ON exchange_rates(exchange_date, currency_id);

CREATE INDEX IF NOT EXISTS idx_exchange_rates_currency_date
    ON exchange_rates(currency_id, exchange_date);

CREATE INDEX IF NOT EXISTS idx_exchange_rates_exchange_currency
    ON exchange_rates(exchange_currency_id);

CREATE INDEX IF NOT EXISTS idx_exchange_rates_bank
    ON exchange_rates(bank_id);

CREATE INDEX IF NOT EXISTS idx_exchange_rates_rate
    ON exchange_rates(currency_id, exchange_date, rate);
