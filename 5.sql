-- Tasks #1694 


CREATE OR REPLACE VIEW "public"."v_geo_cities" AS 
 SELECT c.id,
    c.region_id,
    c.city,
    c.published,
    r.region,
    cn.country
   FROM ((geo_city c
   JOIN geo_region r ON ((r.id = c.region_id)))
   JOIN geo_country cn ON ((cn.id = r.country_id)));
