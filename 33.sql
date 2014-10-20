-- Tasks #124


ALTER TABLE re_object ADD COLUMN commission_total double precision DEFAULT 0 NOT NULL;
ALTER TABLE re_object ADD COLUMN commission_total_type BOOLEAN DEFAULT false NOT NULL;
ALTER TABLE re_object ADD COLUMN commission_partner double precision DEFAULT 0 NOT NULL;
ALTER TABLE re_object ADD COLUMN commission_partner_type BOOLEAN DEFAULT false NOT NULL;
ALTER TABLE re_object ADD COLUMN price_sold double precision DEFAULT 0 NOT NULL;
ALTER TABLE re_object ADD COLUMN currency_sold BIGINT DEFAULT 0 NOT NULL;


COMMENT ON COLUMN public.re_object.measure_id
IS 'Ссылка на единицу измерения площади (measure_au)';

COMMENT ON COLUMN public.re_object.commission_total
IS 'Общая комиссия';

COMMENT ON COLUMN public.re_object.commission_total_type
IS 'false - %, true - сумма';

COMMENT ON COLUMN public.re_object.commission_partner
IS 'Партнерская комиссия';

COMMENT ON COLUMN public.re_object.commission_partner_type
IS 'false - %, true - сумма';

COMMENT ON COLUMN public.re_object.price_sold
IS 'Цена продажи';

COMMENT ON COLUMN public.re_object.currency_sold
IS 'Валюта продажи';


-- View: v_re_object

DROP VIEW v_re_object CASCADE;

CREATE OR REPLACE VIEW v_re_object AS 
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
    o.price / o.area_res::double precision AS price_for_sqm
   FROM re_object o
     JOIN transaction_types tt ON o.transaction_type = tt.type_code
     JOIN re_category c ON o.category_id = c.id AND c.parent <> 0
     JOIN geo_city ct ON o.city_id = ct.id
     LEFT JOIN geo_cityarea cta ON o.cityarea_id = cta.id
     JOIN currency cr ON o.currency_id = cr.id;

-- View: v_object_widget

-- DROP VIEW v_object_widget;

CREATE OR REPLACE VIEW v_object_widget AS 
 SELECT o.*,
    ( SELECT g.path_to_file
           FROM re_object_gal g
          WHERE o.id = g.object_id
          ORDER BY g.sort_order
         LIMIT 1) AS pic
   FROM v_re_object o;