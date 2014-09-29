-- Tasks #1695


CREATE OR REPLACE VIEW "public"."v_geo_cityareas" AS 
   SELECT d.id,
    d.city_id,
    d.name,
    d.published,
    c.city,
    c.region_id,
    r.region,
    r.country_id,
    cn.country
   FROM (((geo_cityarea d
   JOIN geo_city c ON ((c.id = d.city_id)))
   JOIN geo_region r ON ((r.id = c.region_id)))
   JOIN geo_country cn ON ((cn.id = r.country_id)));