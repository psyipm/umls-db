-- Tasks #117


-- drop view v_param_values;
create view v_param_values as

select 
p.id,
p.category_id,
p.param_name_field,
p.label,
p.description,
p.label_is_show,
p.data_type,
p.published,
p.in_search,
p.sort_order,
array_to_string(array_agg(ps._value), '||') as _value,
array_to_string(array_agg(ps.object_id), '||') as object_id
from param p
join (select object_id, param_id, _value from re_object_pset_mono) as ps on (ps.param_id = p.id)
join re_category as c on (c.id = cast(get_var('category_id') as integer))

where p.in_search = 't' and p.published = 't' and (p.category_id = c.id or p.category_id = c.parent)
group by p.id


union all


select 
p.id,
p.category_id,
p.param_name_field,
p.label,
p.description,
p.label_is_show,
p.data_type,
p.published,
p.in_search,
p.sort_order,
array_to_string(array_agg(mv.multivalue), '||') as _value,
array_to_string(array_agg(mv.object_id), '||') as object_id
 from param p
join (select pm.object_id, pm.param_id
	, (select multivalue 
	from param_multivalue m 
	where m.id = pm.checked_id
	order by sort_order)
	from re_object_pset_multi pm) as mv on mv.param_id = p.id
join re_category as c on (c.id = cast(get_var('category_id') as integer))
where p.in_search = 't' and p.published = 't' and (p.category_id = c.id or p.category_id = c.parent)
group by p.id


order by sort_order;