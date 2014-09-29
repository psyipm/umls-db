-- Tasks #27


CREATE OR REPLACE FUNCTION set_var
	(
	  p_var_name varchar,
	  p_var_value varchar 
	)
	RETURNS void AS
	$$
	DECLARE
	  v_cnt integer;
	BEGIN
	  SELECT Count(pc.relname) 
	  into v_cnt
	  FROM pg_catalog.pg_class pc, pg_namespace pn
	  WHERE pc.relname='session_var_tbl' 
	    AND pc.relnamespace=pn.oid 
	    AND pn.oid=pg_my_temp_schema();
	  if v_cnt = 0 then
	    execute 'CREATE GLOBAL TEMPORARY TABLE session_var_tbl (var_name varchar(100) not null, var_value varchar(100)) ON COMMIT preserve ROWS';
	  end if;
	  update session_var_tbl set
	    var_value = p_var_value
	  where var_name = p_var_name;
	  if not FOUND then
	    insert into session_var_tbl(var_name, var_value)
	    values (p_var_name, p_var_value);
	  end if;
	END;
	$$
	LANGUAGE 'plpgsql';


CREATE OR REPLACE FUNCTION get_var
	(
	  p_var_name          varchar 
	)
	RETURNS varchar AS
	$$
	DECLARE
	  v_cnt integer;
	  v_result varchar(100);
	BEGIN
	  SELECT Count(pc.relname) 
	  into v_cnt
	  FROM pg_catalog.pg_class pc, pg_namespace pn
	  WHERE pc.relname='session_var_tbl' 
	    AND pc.relnamespace=pn.oid 
	    AND pn.oid=pg_my_temp_schema();
	  if v_cnt = 0 then
	    v_result := null;
	  else
	    select var_value
	    into v_result
	    from session_var_tbl
	    where var_name = p_var_name;
	    if not FOUND then
	      v_result := null;
	    end if;
	  end if;
	  return v_result;
	END;
	$$
	LANGUAGE 'plpgsql';


-- отправленные сообщения

CREATE TABLE msg_sent(
	id SERIAL,
	subject VARCHAR(256),
	text VARCHAR,
	date_sent timestamp DEFAULT CURRENT_TIMESTAMP,
	sender INTEGER NOT NULL,
	sender_name VARCHAR(50),
	type INTEGER NOT NULL,
	is_draft BOOLEAN NOT NULL,
	recipient_ids varchar,
	recipient_names varchar
	CONSTRAINT msg_sent_pkey PRIMARY KEY(id)
);

COMMENT ON COLUMN msg_sent.subject IS 'Тема сообщения';
COMMENT ON COLUMN msg_sent.text IS 'Текст';
COMMENT ON COLUMN msg_sent.sender IS 'Отправитель (user.id)';
COMMENT ON COLUMN msg_sent.type IS 'Тип сообщения (P Простое, M Важное, S Системное)';


-- sent

DROP VIEW IF EXISTS v_msg_sent;
CREATE VIEW v_msg_sent AS
	SELECT distinct
	s.* 
	, r.recipient_names
	, t.descr AS type_descr
	FROM msg_sent AS s
	JOIN msg_received AS r ON (r.message_id = s.id)
	JOIN msg_types AS t ON (t.code = s.type)

	WHERE s.sender = (SELECT CAST(get_var('user_id') AS INTEGER))
	AND s.is_draft = 'f'

	ORDER BY id DESC;


-- -- draft

CREATE VIEW v_msg_draft AS
	SELECT *, 'Draft' AS type_descr FROM msg_sent AS s
	WHERE s.sender = (SELECT CAST(get_var('user_id') AS INTEGER)) AND s.is_draft = 't';


-- после добавления нового сообщения записываем в таблицу имя отправителя

CREATE FUNCTION public.update_sender_name()
	RETURNS trigger
	AS 
	$body$
	BEGIN

	UPDATE msg_sent SET sender_name = (SELECT name FROM users WHERE id = NEW.sender)
	WHERE sender = NEW.sender;

	return NEW;
	END;
	$body$
	LANGUAGE plpgsql;

CREATE TRIGGER tr_update_sender_name
	AFTER INSERT ON msg_sent
	FOR EACH ROW
	EXECUTE PROCEDURE update_sender_name();


CREATE OR REPLACE FUNCTION update_recipients_names()
	RETURNS TRIGGER
	AS
	$body$
	DECLARE
		v_user_names varchar[];
	BEGIN
		SELECT array_agg(u.name)
		FROM users AS u 
		WHERE (CAST(string_to_array(NEW.recipient_ids, ',') AS integer[])) @> array[u.id]
		INTO v_user_names;

		UPDATE msg_received 
		SET recipient_names = array_to_string(v_user_names, ',')
		WHERE message_id = NEW.message_id;

		RETURN NEW;
	END;
	$body$
	LANGUAGE plpgsql;

CREATE TRIGGER tr_update_recipient_names
	AFTER INSERT ON msg_received
	FOR EACH ROW
	EXECUTE PROCEDURE update_recipients_names();

DROP FUNCTION IF EXISTS set_msg_recipients();


-- входящие сообщения

CREATE TABLE msg_received(
	id SERIAL, 
	message_id INTEGER NOT NULL,
	recipient_id INTEGER NOT NULL,
	state INTEGER NOT NULL DEFAULT 1,
	category INTEGER NOT NULL DEFAULT 0,
	CONSTRAINT msg_received_pkey PRIMARY KEY(id),
	CONSTRAINT msg_sent_id FOREIGN KEY (message_id) REFERENCES msg_sent(id) ON DELETE CASCADE ON UPDATE CASCADE
);

COMMENT ON COLUMN msg_received.message_id IS 'ссылка на сообщение';
COMMENT ON COLUMN msg_received.recipient_id IS 'ссылка на получателя';
COMMENT ON COLUMN msg_received.state IS 'состояние (1 U новое, 2 V прочитанное)';
COMMENT ON COLUMN msg_received.category IS 'категория (0 - без категории, 1 - архивные, 2 - отмеченные)';


CREATE VIEW v_msg_inbox AS
	select 
	s.*
	, t.descr as type_descr
	, r.state
	, r.recipient_id
	, st.descr as state_descr

	from msg_received as r
	join msg_sent as s on (r.message_id = s.id)
	join msg_states as st on (r.state = st.code)
	join msg_types as t on (s.type = t.code)

	where r.recipient_id = (SELECT CAST(get_var('user_id') AS INTEGER))
	and r.category <> 1;



-- состояние сообщения (прочитано/непрочитано)

CREATE TABLE msg_states(
	id SERIAL,
	code INTEGER UNIQUE NOT NULL,
	symbol VARCHAR(4),
	descr VARCHAR(128) NOT NULL,
	CONSTRAINT msg_states_pkey PRIMARY KEY(id)
);

COMMENT ON TABLE msg_states IS 'состояние сообщения (прочитано/непрочитано)';

ALTER TABLE msg_received
  ADD CONSTRAINT fk_msg_received_state FOREIGN KEY (state) REFERENCES msg_states (code)
   ON UPDATE CASCADE ON DELETE CASCADE;
CREATE INDEX fki_msg_received_state
  ON msg_received(state);

INSERT INTO msg_states(code, symbol, descr) VALUES (1, 'U', 'Новое'), (2, 'V', 'Прочитанное');


-- типы сообщений (простое/важное/системное)

CREATE TABLE msg_types(
	id SERIAL,
	code INTEGER UNIQUE NOT NULL,
	symbol VARCHAR(4),
	descr VARCHAR(128) NOT NULL,
	CONSTRAINT msg_types_pkey PRIMARY KEY(id)
);

ALTER TABLE msg_sent
  ADD CONSTRAINT fk_msg_sent_type FOREIGN KEY (type) REFERENCES msg_types (code)
   ON UPDATE CASCADE ON DELETE CASCADE;
CREATE INDEX fki_msg_sent_type
  ON msg_sent(type);

COMMENT ON TABLE msg_types IS 'типы сообщений (простое/важное/системное)';

INSERT INTO msg_types(code, symbol, descr) VALUES(1, 'P', 'Простое'), (2, 'M', 'Важное'), (3, 'S', 'Системное');


-- справочник категорий сообщений (архивные/отмеченные)

CREATE TABLE msg_categories(
	id SERIAL,
	code INTEGER UNIQUE NOT NULL,
	descr VARCHAR(128) NOT NULL,
	CONSTRAINT msg_categories_pkey PRIMARY KEY(id)
);

COMMENT ON TABLE msg_categories IS 'справочник категорий сообщений (архивные/отмеченные)';

alter table msg_received add constraint msg_category_fkey foreign key(category)
references msg_categories(code) on delete cascade on update cascade;

INSERT INTO msg_categories(code, descr) 
VALUES(0, 'Без категории'), (1, 'Архивные'), (2, 'Отмеченные');


-- starred

DROP VIEW IF EXISTS v_msg_starred;
CREATE VIEW v_msg_starred AS
	SELECT 
	s.* 
	, r.state
	, r.recipient_names
	, r.recipient_ids
	, t.descr AS type_descr

	FROM msg_received AS r
	JOIN msg_sent AS s ON(s.id = r.message_id)
	JOIN msg_types AS t ON(t.code = s.type)

	WHERE r.recipient_id = (SELECT CAST(get_var('user_id') AS INTEGER))
	AND r.category = 2

	ORDER BY s.id DESC;


-- archived

DROP VIEW IF EXISTS v_msg_archived;
CREATE VIEW v_msg_archived AS
	SELECT 
	s.*
	, r.state
	, r.recipient_names
	, r.recipient_ids
	, t.descr AS type_descr
	FROM msg_received AS r
	JOIN msg_sent AS s ON(s.id = r.message_id)
	JOIN msg_types AS t ON(t.code = s.type)

	WHERE r.recipient_id = (SELECT CAST(get_var('user_id') AS INTEGER))
	AND r.category = 1

	ORDER BY s.id DESC;

DROP TABLE IF EXISTS msg_recipients;


-- message counts

create view v_msg_counts as

	select 

	(select count(*) from msg_received
	where recipient_id = (SELECT CAST(get_var('user_id') AS INTEGER))
	and state = 1
	and category <> 1) as inbox_new

	, (select count(*) from msg_received
	where recipient_id = (SELECT CAST(get_var('user_id') AS INTEGER))
	and state = 2
	and category <> 1) as inbox_read

	, (select count(*) from msg_sent
	where sender = (SELECT CAST(get_var('user_id') AS INTEGER))
	and is_draft = 'f') as sent

	, (select count(*) from msg_sent
	where sender = (SELECT CAST(get_var('user_id') AS INTEGER))
	and is_draft = 't') as draft

	, (select count(*) from msg_received
	where recipient_id = (SELECT CAST(get_var('user_id') AS INTEGER))
	and category = 2) as starred

	, (select count(*) from msg_received
	where recipient_id = (SELECT CAST(get_var('user_id') AS INTEGER))
	and category = 1) as archived;


-- message recipients
create view v_msg_recipients as
	select 
	id, 
	email, 
	name, 
	name || ' <' || email || '>' as name_email
	from users
	where active = 1;


-- права доступа для ролей
INSERT INTO permissions(permission, descr)
VALUES('umls_messages', 'Использование модуля сообщений');


-- удаляем старые таблицы

DROP TABLE IF EXISTS user_messages;

	-- CREATE TABLE user_messages
	-- (
	--   id integer NOT NULL DEFAULT nextval('messages_id_seq'::regclass),
	--   theme character varying(50), -- Тема
	--   text character varying(65000), -- Текст письма
	--   status integer, -- Простое - 1...
	--   state integer, -- 0 - не прочитано...
	--   sender_id integer, -- Отправитель письма
	--   recipient_id integer, -- Получатель письма
	--   owner_id integer, -- У кого отображается письмо
	--   folder character varying(20), -- Папка
	--   CONSTRAINT user_messages_pkey PRIMARY KEY (id),
	--   CONSTRAINT user_messages_owner_id_fkey FOREIGN KEY (owner_id)
	--       REFERENCES users (id) MATCH SIMPLE
	--       ON UPDATE NO ACTION ON DELETE NO ACTION,
	--   CONSTRAINT user_messages_recipient_id_fkey FOREIGN KEY (recipient_id)
	--       REFERENCES users (id) MATCH SIMPLE
	--       ON UPDATE NO ACTION ON DELETE NO ACTION,
	--   CONSTRAINT user_messages_sender_id_fkey FOREIGN KEY (sender_id)
	--       REFERENCES users (id) MATCH SIMPLE
	--       ON UPDATE NO ACTION ON DELETE NO ACTION
	-- )
	-- WITH (
	--   OIDS=FALSE
	-- );
	-- ALTER TABLE user_messages
	--   OWNER TO postgres;
	-- GRANT ALL ON TABLE user_messages TO postgres;
	-- GRANT ALL ON TABLE user_messages TO public;
	-- COMMENT ON TABLE user_messages
	--   IS 'Переписка';
	-- COMMENT ON COLUMN user_messages.theme IS 'Тема';
	-- COMMENT ON COLUMN user_messages.text IS 'Текст письма';
	-- COMMENT ON COLUMN user_messages.status IS 'Простое - 1
	-- Важное - 2
	-- Системное - 3
	-- ';
	-- COMMENT ON COLUMN user_messages.state IS '0 - не прочитано
	-- 1 - прочитано
	-- ';
	-- COMMENT ON COLUMN user_messages.sender_id IS 'Отправитель письма';
	-- COMMENT ON COLUMN user_messages.recipient_id IS 'Получатель письма';
	-- COMMENT ON COLUMN user_messages.owner_id IS 'У кого отображается письмо';
	-- COMMENT ON COLUMN user_messages.folder IS 'Папка';


-- Index: fki_um_owner

DROP INDEX IF EXISTS fki_um_owner;

	-- CREATE INDEX fki_um_owner
	--   ON user_messages
	--   USING btree
	--   (owner_id);

	-- Index: fki_um_recipient

DROP INDEX IF EXISTS fki_um_recipient;

	-- CREATE INDEX fki_um_recipient
	--   ON user_messages
	--   USING btree
	--   (recipient_id);

	-- Index: fki_um_sender_id

DROP INDEX IF EXISTS fki_um_sender_id;

	-- CREATE INDEX fki_um_sender_id
	--   ON user_messages
	--   USING btree
	--   (sender_id);


-- Table: user_messages_archive

DROP TABLE IF EXISTS user_messages_archive;

	-- CREATE TABLE user_messages_archive
	-- (
	--   id integer NOT NULL,
	--   theme character varying(50), -- Тема
	--   text character varying(65000), -- Текст письма
	--   status integer, -- Простое - 1...
	--   state integer, -- 0 - не прочитано...
	--   sender_id integer, -- Отправитель письма
	--   recipient_id integer, -- Получатель письма
	--   owner_id integer, -- У кого отображается письмо
	--   folder character varying(20),
	--   CONSTRAINT user_messages_archive_pkey PRIMARY KEY (id),
	--   CONSTRAINT user_messages_archive_owner_id_fkey FOREIGN KEY (owner_id)
	--       REFERENCES users (id) MATCH SIMPLE
	--       ON UPDATE NO ACTION ON DELETE NO ACTION,
	--   CONSTRAINT user_messages_archive_recipient_id_fkey FOREIGN KEY (recipient_id)
	--       REFERENCES users (id) MATCH SIMPLE
	--       ON UPDATE NO ACTION ON DELETE NO ACTION,
	--   CONSTRAINT user_messages_archive_sender_id_fkey FOREIGN KEY (sender_id)
	--       REFERENCES users (id) MATCH SIMPLE
	--       ON UPDATE NO ACTION ON DELETE NO ACTION
	-- )
	-- WITH (
	--   OIDS=FALSE
	-- );
	-- ALTER TABLE user_messages_archive
	--   OWNER TO postgres;
	-- GRANT ALL ON TABLE user_messages_archive TO postgres;
	-- GRANT ALL ON TABLE user_messages_archive TO public;
	-- COMMENT ON TABLE user_messages_archive
	--   IS 'Переписка';
	-- COMMENT ON COLUMN user_messages_archive.theme IS 'Тема';
	-- COMMENT ON COLUMN user_messages_archive.text IS 'Текст письма';
	-- COMMENT ON COLUMN user_messages_archive.status IS 'Простое - 1
	-- Важное - 2
	-- Системное - 3
	-- ';
	-- COMMENT ON COLUMN user_messages_archive.state IS '0 - не прочитано
	-- 1 - прочитано
	-- ';
	-- COMMENT ON COLUMN user_messages_archive.sender_id IS 'Отправитель письма';
	-- COMMENT ON COLUMN user_messages_archive.recipient_id IS 'Получатель письма';
	-- COMMENT ON COLUMN user_messages_archive.owner_id IS 'У кого отображается письмо';


-- Index: fki_uma_owner

DROP INDEX IF EXISTS fki_uma_owner;

	-- CREATE INDEX fki_uma_owner
	--   ON user_messages_archive
	--   USING btree
	--   (owner_id);

-- Index: fki_uma_recipient

DROP INDEX IF EXISTS fki_uma_recipient;

	-- CREATE INDEX fki_uma_recipient
	--   ON user_messages_archive
	--   USING btree
	--   (recipient_id);

-- Index: fki_uma_sender_id

DROP INDEX IF EXISTS fki_uma_sender_id;

	-- CREATE INDEX fki_uma_sender_id
	--   ON user_messages_archive
	--   USING btree
	--   (sender_id);


-- Table: user_messages_count

DROP TABLE IF EXISTS user_messages_count;

	-- CREATE TABLE user_messages_count
	-- (
	--   id integer NOT NULL DEFAULT nextval('user_messages_count_id_seq'::regclass),
	--   user_id integer, -- Чей счетчик
	--   folder character varying(30), -- Папка в к которой относится счетчик
	--   count integer, -- Количество писем в папке
	--   CONSTRAINT user_messages_count_pkey PRIMARY KEY (id),
	--   CONSTRAINT user_messages_count_user_id_fkey FOREIGN KEY (user_id)
	--       REFERENCES users (id) MATCH SIMPLE
	--       ON UPDATE NO ACTION ON DELETE NO ACTION
	-- )
	-- WITH (
	--   OIDS=FALSE
	-- );
	-- ALTER TABLE user_messages_count
	--   OWNER TO postgres;
	-- GRANT ALL ON TABLE user_messages_count TO postgres;
	-- GRANT ALL ON TABLE user_messages_count TO public;
	-- COMMENT ON TABLE user_messages_count
	--   IS 'Счетчики сообщений';
	-- COMMENT ON COLUMN user_messages_count.user_id IS 'Чей счетчик';
	-- COMMENT ON COLUMN user_messages_count.folder IS 'Папка в к которой относится счетчик';
	-- COMMENT ON COLUMN user_messages_count.count IS 'Количество писем в папке';


-- Index: fki_um_count_user_id

DROP INDEX IF EXISTS fki_um_count_user_id;

	-- CREATE INDEX fki_um_count_user_id
	--   ON user_messages_count
	--   USING btree
	--   (user_id);