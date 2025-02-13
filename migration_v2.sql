ALTER TABLE exchange_rates
ADD COLUMN source VARCHAR(50);

UPDATE exchange_rates
SET source = 'Default Source'
WHERE source IS NULL;

COMMENT ON COLUMN exchange_rates.source IS 'Источник данных для курса валют';
