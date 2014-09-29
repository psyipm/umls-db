-- Tasks #92


ALTER TABLE roles ADD COLUMN system_role_id integer default 0 not null;
COMMENT ON COLUMN roles.system_role_id IS 'Признак системной роли. Системная роль не может быть удалена. 1 - Администратор Объектов, 2 - Администратор Пользователей';

UPDATE roles SET system_role_id = 1 WHERE id = 7;


CREATE OR REPLACE VIEW v_system_users AS 
 SELECT 
 u.id
 , u.email
 , u.name
 , u.active
 , r. system_role_id
 FROM users AS u
 JOIN user_roles AS ur ON ur.user_id = u.id
 JOIN roles AS r ON r.id = ur.role_id
 WHERE r.system_role_id = (SELECT CAST(get_var('system_role_id') AS INTEGER));


CREATE OR REPLACE VIEW v_super_users AS
SELECT u.id,
    u.email,
    u.name,
    u.active FROM users AS u
JOIN super_users AS su ON su.email = u.email
ORDER BY u.id;


INSERT INTO email_templates(name, tpl_file, tpl_vars)
VALUES
('Активация пользователя', 'email/user-activated', '{{user_email}},{{user_name}},{{user_phone}},{{admin_name}},{{admin_email}}'), 
('Деактивация пользователя', 'email/user-deactivated', '{{user_email}},{{user_name}},{{user_phone}},{{admin_name}},{{admin_email}}');


create view v_system_role_by_user_id as
select 
u.id,
u.email,
u.name,
u.active,
r.system_role_id
from users as u
join user_roles as ur on ur.user_id = u.id
join roles as r on r.id = ur.role_id

where u.id = (select cast(get_var('user_id') as integer));


INSERT INTO email_templates(name, tpl_file, tpl_vars)
VALUES
('Объект деактивирован Администратором объектов', 'email/object-deactivated', '{{object_id}},{{object_street}},{{object_building}},{{admin_name}},{{admin_email}}');
