-- Tasks #72


INSERT INTO email_templates(name, tpl_file, tpl_vars)
VALUES('Обратная связь', 'email/feedback', '{{sender_name}},{{email}},{{phone}},{{message}}');