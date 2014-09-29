-- Tasks #84

DROP VIEW v_param_wtypes;
CREATE OR REPLACE VIEW v_param_wtypes AS 
 SELECT p.id,
    p.category_id,
    c.name AS category_name,
    p.param_name_field,
    p.label,
    p.description,
    p.label_is_show,
    p.data_type,
    p.published,
    p.in_search,
    p.sort_order,
    pt.symbol AS data_type_symbol,
    pt.validator_regexp
   FROM param p
     JOIN param_data_types pt ON p.data_type = pt.data_type_id
	JOIN re_category c ON c.id = p.category_id;