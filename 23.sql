-- Tasks #81


TRUNCATE TABLE permissions CASCADE;

INSERT INTO permissions(permission, descr)
VALUES 
('admin-panel\global-settings', 'Редактирование общих настроек системы'),
('admin-panel\email-templates', 'Редактирование шаблонов системных сообщений'),
('admin-panel\syslogview', 'Просмотр логов системы'),
('admin-panel\news', 'Редактирование новостей'),
('admin-panel\links', 'Редактирование ссылок'),
('accounts\accountlist', 'Редактирование аккаунтов'),
('roles\roleslist', 'Редактирование ролей'),
('admin-panel\agents', 'Редактирование агентов'),
('admin-panel\countries-catalog', 'Справочник стран'),
('admin-panel\regions-catalog', 'Справочник областей'),
('admin-panel\cities-catalog', 'Справочник городов'),
('admin-panel\districts-catalog', 'Справочник районов'),
('admin-panel\currencies-catalog', 'Справочник валют'),
('admin-panel\objects-categories', 'Справочник категорий объектов'),
('admin-panel\category-params-set', 'Набор параметров категории'),
('admin-panel\parameters', 'Справочник параметров'),
('admin-panel\objects', 'Справочник объектов');


-- remove triggers on param and re_category
DROP TRIGGER IF EXISTS tr_param ON param;
DROP FUNCTION IF EXISTS new_param_add();

DROP TRIGGER IF EXISTS tr_re_category ON re_category;
DROP FUNCTION IF EXISTS new_category_add();
