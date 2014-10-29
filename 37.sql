-- Tasks #118


ALTER TABLE currency
ADD COLUMN bid double precision NOT NULL DEFAULT 1,
ADD COLUMN ask double precision NOT NULL DEFAULT 1,
ADD COLUMN last_update timestamp without time zone NOT NULL DEFAULT now();

COMMENT ON COLUMN currency.bid IS 'Цена покупки за единицу валюты по отношению к USD';
COMMENT ON COLUMN currency.ask IS 'Цена продажи за единицу валюты по отношению к USD';
COMMENT ON COLUMN currency.last_update IS 'Дата последнего обновления';