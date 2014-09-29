-- Tasks #1693

CREATE OR REPLACE VIEW v_geo_regions AS
SELECT 
r.ig,
cn.country,
cn.id as country_id,
r.region,
r.published
from geo_region AS r
INNER JOIN geo_country AS cn ON(r.country_id = cn."id");