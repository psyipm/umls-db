-- Tasks #104
-- Tasks #105


ALTER TABLE param_category
  ADD CONSTRAINT param_category_pkey PRIMARY KEY (id);


DROP VIEW v_params_set;
CREATE OR REPLACE VIEW v_params_set AS 
 SELECT p.id,
    p.category_id,
    rc.parent AS parent_category_id,
    p.param_name_field,
    p.label,
    p.description,
    p.label_is_show,
    p.data_type,
    p.published,
    p.in_search,
    p.sort_order,
    pt.symbol,
    pt.descr,
    pt.min_values_count,
    pt.zend_element_name,
    pt.validator_regexp,
    ps.value_o,
    ps.value_a
   FROM param p
     JOIN param_data_types pt ON p.data_type = pt.data_type_id
     JOIN re_category rc ON rc.id = p.category_id
     JOIN re_cparam_set ps ON ps.param_id = p.id
  WHERE p.published = true
  ORDER BY p.sort_order;


update param_data_types set validator_regexp = '^\d{1,}$' where data_type_id = 7;


DROP VIEW v_re_object;

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
     LEFT OUTER JOIN geo_cityarea cta ON o.cityarea_id = cta.id
     JOIN currency cr ON o.currency_id = cr.id;



-- truncate table re_object restart identity cascade;
-- truncate table re_object_doc restart identity;
-- truncate table re_object_gal restart identity;
-- truncate table re_cparam_set restart identity;
-- truncate table param_multivalue restart identity cascade;
-- truncate table re_object_pset_mono restart identity cascade;
-- truncate table re_object_pset_multi restart identity cascade;
-- truncate table param_category restart identity;
-- truncate table param restart identity cascade;
-- truncate table re_category restart identity;