-- Tasks #112


create view v_object_widget as 
select 
o.*,
(select path_to_file from re_object_gal as g
where o.id = g.object_id
order by g.sort_order
limit 1) as pic

from v_re_object as o;