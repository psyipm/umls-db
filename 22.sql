-- Tasks #23

SET check_function_bodies = false;
--
-- Definition for function new_param_add (OID = 33945) : 
--
SET search_path = public, pg_catalog;
CREATE FUNCTION public.new_param_add (
)
RETURNS trigger
AS 
$body$
DECLARE
  category_cur CURSOR FOR select id from re_category ;
  cat_id integer;
BEGIN

/*при создании нового параметра  - тиражируем его для всех наборов параметров*/

OPEN category_cur;
LOOP
FETCH category_cur INTO cat_id;
IF NOT FOUND THEN EXIT;END IF;

INSERT INTO re_cparam_set
(
  category_id,
  param_id,
  value_o,
  value_d,
  value_a,
  value_tab,
  value_tile
)
VALUES (
  cat_id,
  NEW.id,
  false,
  false,
  0,
  false,
  false
);



END LOOP;
CLOSE category_cur; 
return NEW;

END;
$body$
LANGUAGE plpgsql;
--
-- Definition for function new_category_add (OID = 33946) : 
--
CREATE FUNCTION public.new_category_add (
)
RETURNS trigger
AS 
$body$
DECLARE
  param_cur CURSOR FOR select id from param ;
  tparam_id integer;
  
BEGIN

/*при создании новой категории  - тиражируем для неё все наборы параметров*/

OPEN param_cur;
LOOP
FETCH param_cur INTO tparam_id;
IF NOT FOUND THEN EXIT;END IF;

INSERT INTO re_cparam_set
(
  category_id,
  param_id,
  value_o,
  value_d,
  value_a,
  value_tab,
  value_tile
)
VALUES (
  new.id,
  tparam_id,
  false,
  false,
  0,
  false,
  false
);


END LOOP;
CLOSE param_cur; 
return NEW;

END;
$body$
LANGUAGE plpgsql;
--
-- Definition for function param_update (OID = 42124) : 
--
DROP TRIGGER IF EXISTS tr_param_update ON param;
DROP FUNCTION IF EXISTS param_update();

CREATE FUNCTION public.param_update (
)
RETURNS trigger
AS 
$body$
BEGIN
/*при изменении категории в параметре - обновляем для всех записей в наборе параметров*/
IF OLD.category_id <> NEW.category_id THEN
   UPDATE 
             public.re_cparam_set 
   SET  
             category_id = NEW.category_id
            WHERE    
             param_id = NEW.id;
        END IF;
return NEW;
END;
$body$
LANGUAGE plpgsql;


-- View: v_re_cparam_set
DROP VIEW v_re_cparam_set;
--
-- Structure for table re_cparam_set (OID = 25597) : 
--
DROP TABLE IF EXISTS public.re_cparam_set;
CREATE TABLE public.re_cparam_set (
    id serial NOT NULL,
    category_id integer NOT NULL,
    param_id integer NOT NULL,
    value_o boolean DEFAULT false NOT NULL,
    value_d boolean DEFAULT false NOT NULL,
    value_a integer DEFAULT 0 NOT NULL,
    value_tab boolean DEFAULT false NOT NULL,
    value_tile boolean DEFAULT false NOT NULL
)
WITH (oids = false);

--
-- Definition for index re_cparam_set_idx (OID = 25608) : 
--
CREATE INDEX re_cparam_set_idx ON re_cparam_set USING btree (category_id);
--
-- Definition for index re_cparam_set_idx1 (OID = 25609) : 
--
CREATE INDEX re_cparam_set_idx1 ON re_cparam_set USING btree (param_id);

--
-- Definition for index re_cparam_set_pkey (OID = 25606) : 
--
ALTER TABLE ONLY re_cparam_set
    ADD CONSTRAINT re_cparam_set_pkey
    PRIMARY KEY (id);


CREATE VIEW v_re_cparam_set AS
select 
ps.*,
c.name as params_category,
p.label as param_field_name,
p.sort_order as order,
pdt.descr as param_type

from re_cparam_set as ps
join re_category as c on (c.id = ps.category_id)
join param as p on (p.id = ps.param_id)
join param_data_types as pdt on (pdt.data_type_id = p.data_type);

ALTER TABLE v_re_cparam_set
  OWNER TO postgres;
GRANT ALL ON TABLE v_re_cparam_set TO postgres;
GRANT ALL ON TABLE v_re_cparam_set TO public;

--
-- Definition for trigger tr_param (OID = 33951) : 
--
CREATE TRIGGER tr_param
    AFTER INSERT ON param
    FOR EACH ROW
    EXECUTE PROCEDURE new_param_add ();
--
-- Definition for trigger tr_re_category (OID = 33952) : 
--
CREATE TRIGGER tr_re_category
    AFTER INSERT ON re_category
    FOR EACH ROW
    EXECUTE PROCEDURE new_category_add ();
--
-- Comments
--
COMMENT ON SCHEMA public IS 'standard public schema';
COMMENT ON TABLE public.re_category IS 'Справочник категорий объектов (дерево)';
COMMENT ON COLUMN public.re_category.parent IS 'ссылка на материнскую категорию';
COMMENT ON COLUMN public.re_category.name IS 'наименование категории';
COMMENT ON COLUMN public.re_category.info IS 'описание категории';
COMMENT ON COLUMN public.re_category.sort_order IS 'порядок в категории';
COMMENT ON COLUMN public.re_category.category_image IS 'ссылка на файл с изображением для категории';
COMMENT ON COLUMN public.re_category.measure_id IS 'единица измерения по умолчанию для категории(measured_au)';
COMMENT ON COLUMN public.param.category_id IS 'ссылка на категорию';
COMMENT ON COLUMN public.param.name_field IS 'наименование параметра (на англ)';
COMMENT ON COLUMN public.param.label IS 'заголовок параметра';
COMMENT ON COLUMN public.param.description IS 'Подсказка к параметру, отображается в хинте, при наведении курсора на параметр';
COMMENT ON COLUMN public.param.label_is_show IS 'отображать заголовок параметра';
COMMENT ON COLUMN public.param.data_type IS 'тип параметра: 1- целое (I), 2-десятичное (R), 3-строка (S),4- дата (D), 5-чек-бокс (CHb, минимум 1 значение, произвольный выбор), 6-радиокнопка (RDb, минимум 2 значения, выбор только 1 значения), 7-список (L), минимум 2 значения, выбор только одного';
COMMENT ON COLUMN public.param.published IS 'параметр опубликован ?)';
COMMENT ON COLUMN public.param.in_search IS 'параметр используется в поиске?';
COMMENT ON COLUMN public.param.sort_order IS 'порядок отображения в рамках категории';
COMMENT ON TABLE public.re_cparam_set IS 'Набор параметров для категорий
';
COMMENT ON COLUMN public.re_cparam_set.category_id IS 'ссылка на категорию';
COMMENT ON COLUMN public.re_cparam_set.param_id IS 'ссылка на id параметра';




create table access_level_codes (
	id serial,
	code integer not null default 0,
	symbol varchar(4) not null
);

insert into access_level_codes(code, symbol) 
values (0, 'G'),(1, 'R'), (2, 'A');


CREATE TRIGGER tr_param_update
	AFTER UPDATE ON param
	FOR EACH ROW
	EXECUTE PROCEDURE param_update();