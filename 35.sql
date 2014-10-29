-- Tasks #133


create view v_object_pset_mono as

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
ps.object_id,
ps._value

from re_object_pset_mono ps
join param p on p.id = ps.param_id

where p.published = 't';


create view v_object_pset_multi as

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
mv.object_id,
array_to_string(array_agg(mv.multivalue), '||') as _value

from param p

join (select pm.object_id, pm.param_id
, (select multivalue 
	from param_multivalue m 
	where m.id = pm.checked_id
	order by sort_order)

from re_object_pset_multi pm

where pm.object_id = (SELECT CAST(get_var('object_id') AS INTEGER))) as mv on mv.param_id = p.id

where p.published = 't'
group by p.id, mv.object_id;



create view v_object_all_params as

select * from v_object_pset_mono s
where s.object_id = (SELECT CAST(get_var('object_id') AS INTEGER))

union all 

select * from v_object_pset_multi m

order by sort_order;


create or replace rule v_object_widget_upd_vcount as
	on update to v_object_widget do instead update re_object set count_view = count_view + 1
	where id = NEW.id;


insert into email_templates(name, tpl_file, tpl_vars)
values('Информация об объекте UMLS', 'email/share-object', '{{user_email}},{{user_name}},{{object_info | raw}}');


alter table agents add column photo varchar(512) default '/img/noavatar.gif';


drop view if exists v_agent_info;

create view v_agent_info as
select 
a.*,
u.email,
(select array_to_string(array_prepend(u.phone, array_agg(p.phone)), '||')
from agents_phones p
where p.agent_id = a.id) as phones

from agents a

join users u on (u.id = a.user_id);