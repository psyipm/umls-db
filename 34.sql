-- Tasks #114


INSERT INTO permissions(permission, descr)
VALUES 
('user-interface\system-news', 'Просмотр новостей системы'),
('user-interface\my-objects', 'Доступ к разделу "Мои объекты"');


 CREATE OR REPLACE VIEW v_my_objects AS 
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
     JOIN currency cr ON o.currency_id = cr.id
     JOIN agents a ON a.id = o.agent_id

     WHERE a.user_id = (SELECT CAST(get_var('user_id') AS INTEGER));