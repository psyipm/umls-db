-- Tasks #1693


-- fix misspeled column name 'ig' to 'id' in sequence, table and view

ALTER TABLE "public"."geo_region" RENAME "ig" TO "id";


ALTER SEQUENCE "public"."geo_region_ig_seq"
 OWNED BY "public"."geo_region"."id";

DROP VIEW "public"."v_geo_regions";
CREATE OR REPLACE VIEW "public"."v_geo_regions" AS 
 SELECT r.id,
    cn.country,
    cn.id AS country_id,
    r.region,
    r.published
   FROM (geo_region r
   JOIN geo_country cn ON ((r.country_id = cn.id)));
