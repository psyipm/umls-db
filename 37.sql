-- Tasks #118


ALTER TABLE currency
ADD COLUMN bid double precision NOT NULL DEFAULT 1,
ADD COLUMN ask double precision NOT NULL DEFAULT 1,
ADD COLUMN last_update timestamp without time zone NOT NULL DEFAULT now();

COMMENT ON COLUMN currency.bid IS 'Цена покупки за единицу валюты по отношению к USD';
COMMENT ON COLUMN currency.ask IS 'Цена продажи за единицу валюты по отношению к USD';
COMMENT ON COLUMN currency.last_update IS 'Дата последнего обновления';


CREATE OR REPLACE FUNCTION convert_to_usd
	(
	  p_amount double precision,
	  p_currency_id integer 
	)
	RETURNS double precision AS
	$$
	DECLARE
	  v_exchange_rate double precision;
	BEGIN
	  SELECT bid
	  into v_exchange_rate
	  FROM currency
	  WHERE id = p_currency_id;

	  return p_amount*v_exchange_rate;
	END;
	$$
	LANGUAGE 'plpgsql';




-- DROP VIEW v_re_object_by_price;

CREATE OR REPLACE VIEW v_re_object_by_price AS 

SELECT o.id,
   o.transaction_type,
   o.category_id,
   o.country_id,
   o.region_id,
   o.city_id,
   o.cityarea_id,
   o.geo_lat,
   o.geo_long,
   o.street,
   o.build,
   o.price,
   o.currency_id,
   o.price_for,
   o.reff,
   o.agent_id,
   o.data_create,
   o.data_renew,
   o.data_action,
   o.data_unact,
   o.data_sold,
   o.data_del,
   o.is_del,
   o.is_umls_user,
   o.published,
   o.count_view,
   o.meta_keyword,
   o.meta_description,
   o.meta_title,
   o.tags,
   o.info_short,
   o.info_full,
   o.video_link,
   o.state,
   o.area_gen,
   o.area_res,
   o.measure_id,
   o.commission_total,
   o.commission_total_type,
   o.commission_partner,
   o.commission_partner_type,
   o.price_sold,
   o.currency_sold,
   tt.name AS transaction_type_name,
   c.name AS category_name,
   ct.city AS city_name,
   cta.name AS cityarea_name,
   cr.short_name AS currency,
   o.price / o.area_res::double precision AS price_for_sqm,
   f.id as favorites,
   ( SELECT g.path_to_file
           FROM re_object_gal g
          WHERE o.id = g.object_id
          ORDER BY g.sort_order
         LIMIT 1) AS pic
  FROM re_object o
    JOIN transaction_types tt ON o.transaction_type = tt.type_code
    JOIN re_category c ON o.category_id = c.id AND c.parent <> 0
    JOIN geo_city ct ON o.city_id = ct.id
    LEFT JOIN geo_cityarea cta ON o.cityarea_id = cta.id
    JOIN currency cr ON o.currency_id = cr.id
    LEFT JOIN favorites f ON f.object_id = o.id AND f.user_id = CAST(get_var('user_id') AS INTEGER)
   where 
   convert_to_usd(o.price, o.currency_id)
   between
       convert_to_usd(CAST(get_var('price_min') AS DOUBLE PRECISION), CAST(get_var('currency_id') AS INTEGER))
       and
       convert_to_usd(CAST(get_var('price_max') AS DOUBLE PRECISION), CAST(get_var('currency_id') AS INTEGER));