ALTER TABLE exchange_rates
    ADD COLUMN buy_rate NUMERIC(10, 4) NOT NULL,
    ADD COLUMN sell_rate NUMERIC(10, 4) NOT NULL;

UPDATE exchange_rates
SET buy_rate = rate, sell_rate = rate;

ALTER TABLE banks
    ADD COLUMN country_id INTEGER;

UPDATE banks
SET country_id = (SELECT id FROM countries WHERE code = 'US')
WHERE name = 'Bank of America';

UPDATE banks
SET country_id = (SELECT id FROM countries WHERE code = 'EU')
WHERE name = 'European Central Bank';

UPDATE banks
SET country_id = (SELECT id FROM countries WHERE code = 'GB')
WHERE name = 'Bank of England';

UPDATE banks
SET country_id = (SELECT id FROM countries WHERE code = 'JP')
WHERE name = 'Bank of Japan';

ALTER TABLE banks
    ALTER COLUMN country_id SET NOT NULL,
    ADD CONSTRAINT fk_bank_country FOREIGN KEY (country_id) REFERENCES countries(id);

ALTER TABLE banks
    ADD CONSTRAINT unique_bank_country UNIQUE (name, country_id);
