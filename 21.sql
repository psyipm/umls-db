-- Tasks #66

CREATE VIEW "v_role_permissions" AS 
	select 
		"r"."id" AS "id",
		"r"."name" AS "name",
		"r"."descr" AS "descr",
		(select array_to_string(array_agg(rp.permission_id), ',') -- group_concat("rp"."permission_id" separator ',') 
			from "role_permissions" "rp" 
			where ("rp"."role_id" = "r"."id") 
			group by "rp"."role_id") AS "permissions" 
		from "roles" "r" ;


DROP VIEW IF EXISTS "v_user_roles";
CREATE VIEW "v_user_roles" AS 
SELECT 
u.id,
u.email,
u.phone,
u.name,
u.active as state,
(SELECT array_to_string(array_agg("ur"."role_id"), ',')
	from user_roles as ur
	where ur.user_id = u.id
	group by u.id
) as roles

FROM users as u;