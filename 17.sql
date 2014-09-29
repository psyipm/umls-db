-- Tasks #43

DROP TABLE IF EXISTS agents;

CREATE TABLE agents (
	id SERIAL,
	name_f VARCHAR(128) NOT NULL,
	name_n VARCHAR(128) NOT NULL,
	name_o VARCHAR(128),
	agency_id INTEGER DEFAULT 0 NOT NULL,
	user_id INTEGER DEFAULT 0 NOT NULL,
	skype VARCHAR(128),
	viber VARCHAR(128),
	site VARCHAR(128),
	city_id INTEGER DEFAULT 0 NOT NULL,
	address VARCHAR(255),
	CONSTRAINT agents_pkey PRIMARY KEY(id))
WITH (oids = false);

COMMENT ON COLUMN agents.name_f IS 'Фамилия';
COMMENT ON COLUMN agents.name_n IS 'Имя';
COMMENT ON COLUMN agents.name_o IS 'Отчество';
COMMENT ON COLUMN agents.agency_id IS 'ссылка на агентство';
COMMENT ON COLUMN agents.user_id IS 'ссылка на пользователя системы';
COMMENT ON COLUMN agents.city_id IS 'ссылка на город';
COMMENT ON COLUMN agents.address IS 'адрес офиса';


CREATE TABLE agents_phones (
	id SERIAL,
	agent_id INTEGER DEFAULT 0 NOT NULL,
	phone VARCHAR(14),
	CONSTRAINT agents_phones_pkey PRIMARY KEY(id))
WITH (oids = false);

ALTER TABLE agents_phones
  ADD CONSTRAINT agent_id_fkey FOREIGN KEY (agent_id) REFERENCES agents (id) ON UPDATE NO ACTION ON DELETE NO ACTION;


ALTER TABLE agents
   ADD COLUMN country_id integer NOT NULL DEFAULT 0;
COMMENT ON COLUMN agents.country_id
  IS 'ссылка на страну';

ALTER TABLE agents
   ADD COLUMN region_id integer NOT NULL DEFAULT 0;
COMMENT ON COLUMN agents.region_id
  IS 'ссылка на область';


DROP VIEW IF EXISTS v_agents;

CREATE VIEW v_agents AS
SELECT
	a.*,
	u.email,
	u.phone,
	c.city,
	u.active
FROM agents as a
JOIN users as u ON (u.id = a.user_id)
JOIN geo_city as c ON (c.id = a.city_id);