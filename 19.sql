-- Tasks #56

CREATE TABLE email_templates
(
  id serial,
  name character varying(128) NOT NULL, -- Имя шаблона
  tpl_file character varying(256) NOT NULL, -- относительный путь к файлу шаблона
  tpl_vars character varying(256), -- Список обязательных переменных, через запятую
  CONSTRAINT email_templates_pkey PRIMARY KEY(id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE email_templates
  OWNER TO pgprog;
COMMENT ON TABLE email_templates
  IS 'Шаблоны системных сообщений';
COMMENT ON COLUMN email_templates.name IS 'Имя шаблона';
COMMENT ON COLUMN email_templates.tpl_file IS 'относительный путь к файлу шаблона';
COMMENT ON COLUMN email_templates.tpl_vars IS 'Список обязательных переменных, через запятую';
