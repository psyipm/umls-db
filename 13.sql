DROP VIEW IF EXISTS public.v_re_object;
DROP TABLE IF EXISTS re_object;

CREATE TABLE public.re_object (
    id serial NOT NULL,
    transaction_type integer NOT NULL,
    category_id integer NOT NULL,
    country_id integer DEFAULT 0 NOT NULL,
    region_id integer DEFAULT 0 NOT NULL,
    city_id integer NOT NULL,
    cityarea_id integer DEFAULT 0 NOT NULL,
    geo_lat double precision,
    geo_long double precision,
    street varchar(255) NOT NULL,
    build varchar(12) NOT NULL,
    price double precision NOT NULL,
    currency_id integer NOT NULL,
    price_for integer DEFAULT 0 NOT NULL,
    reff varchar(12),
    agent_id integer NOT NULL,
    data_create date NOT NULL,
    data_renew date NOT NULL,
    data_action date,
    data_unact date,
    data_sold date,
    data_del date,
    is_del boolean DEFAULT false NOT NULL,
    is_umls_user boolean DEFAULT true NOT NULL,
    published boolean DEFAULT true NOT NULL,
    count_view integer DEFAULT 0 NOT NULL,
    meta_keyword varchar(255),
    meta_description varchar(200),
    meta_title varchar(80),
    tags varchar(255),
    info_short varchar(1000) NOT NULL,
    info_full varchar NOT NULL,
    video_link varchar(255),
    state integer DEFAULT 0 NOT NULL,
    area_gen numeric(12,2) DEFAULT 1 NOT NULL,
    area_res numeric(12,2) DEFAULT 1 NOT NULL,
    measure_id integer DEFAULT 1 NOT NULL
)
WITH (oids = false);
ALTER TABLE ONLY public.re_object ALTER COLUMN id SET STATISTICS 0;
ALTER TABLE ONLY public.re_object ALTER COLUMN city_id SET STATISTICS 0;


-- Definition for index ra_object_pkey (OID = 25654) : 
--
ALTER TABLE ONLY re_object
    ADD CONSTRAINT ra_object_pkey
    PRIMARY KEY (id);


COMMENT ON TABLE public.re_object IS 'Справочник объектов';
COMMENT ON COLUMN public.re_object.transaction_type IS 'тип сделки по объекту 0-продажа, 1-аренда';
COMMENT ON COLUMN public.re_object.category_id IS 'категория объекта, из справочника категорий. Не может быть выбрана «узловая категория», т.е. категория у которой существуют подкатегории';
COMMENT ON COLUMN public.re_object.country_id IS 'Страна';
COMMENT ON COLUMN public.re_object.region_id IS 'область';
COMMENT ON COLUMN public.re_object.city_id IS 'Населенный пункт объекта, или ближайший к объекту населенный пункт';
COMMENT ON COLUMN public.re_object.cityarea_id IS 'Ссылка на район населенного пункта';
COMMENT ON COLUMN public.re_object.geo_lat IS 'Широта, в десятичных градусах';
COMMENT ON COLUMN public.re_object.geo_long IS 'Долгота, в десятичных градусах';
COMMENT ON COLUMN public.re_object.street IS 'улица объекта прописью *';
COMMENT ON COLUMN public.re_object.build IS 'build – номер здания *';
COMMENT ON COLUMN public.re_object.price IS 'цена объекта. Для продажи цена в выбранной валюте, для аренды цена аренды за период (на выбор: Сутки/Неделя/Месяц/Квартал/Полугодие/Год)';
COMMENT ON COLUMN public.re_object.currency_id IS 'currency_id – валюта цены (выбирается из справочника валют)';
COMMENT ON COLUMN public.re_object.price_for IS 'Цена за
0 - за объект (если продажа)
1 - за сутки (если аренда)
2 - за неделю (если аренда)
3 - за месяц (если аренда)
4 - за квартал (если аренда)
5 - за полугодие (если аренда)
6 - за год (если аренда)';
COMMENT ON COLUMN public.re_object.reff IS 'Реферальный номер';
COMMENT ON COLUMN public.re_object.agent_id IS 'Агент, владелец объекта';
COMMENT ON COLUMN public.re_object.data_create IS 'Дата создания объекта';
COMMENT ON COLUMN public.re_object.data_renew IS 'Дата последнего обновления объекта';
COMMENT ON COLUMN public.re_object.data_action IS 'Дата отметки "Акция"';
COMMENT ON COLUMN public.re_object.data_unact IS 'Дата автоматического снятия с публикации';
COMMENT ON COLUMN public.re_object.data_sold IS 'data_sold – дата продажи объекта (если сделка по объекту закончилась продажей)';
COMMENT ON COLUMN public.re_object.data_del IS 'data_del – дата удаления объекта из системы  (для пользователя системы не отображается, доступен только суперадминистратору)';
COMMENT ON COLUMN public.re_object.is_del IS 'Объект удален ?';
COMMENT ON COLUMN public.re_object.is_umls_user IS 'Укзатель того что объект принадлежит пользователю UMLS';
COMMENT ON COLUMN public.re_object.published IS 'Объект опубликован ?';
COMMENT ON COLUMN public.re_object.count_view IS 'count_view – счетчик показов объекта * (для пользователя системы только для чтения, доступен полностью только суперадминистратору)';
COMMENT ON COLUMN public.re_object.meta_keyword IS 'meta_keyword – ключевые слова (<meta name="keywords" content=" " /> на странице объекта) *';
COMMENT ON COLUMN public.re_object.meta_description IS 'meta_description – ключевая информация (  <meta name="description" content=" " /> на странице объекта) *';
COMMENT ON COLUMN public.re_object.meta_title IS 'meta_title – ключевая информация (  <meta name="title" content=" " /> на странице объекта) *';
COMMENT ON COLUMN public.re_object.tags IS 'tags – теги объекта';
COMMENT ON COLUMN public.re_object.info_short IS 'info_short – краткое описание объекта (простой текст) *';
COMMENT ON COLUMN public.re_object.info_full IS 'info_full – полное описание объекта (html) *';
COMMENT ON COLUMN public.re_object.video_link IS 'video_link – код для вставки видео';
COMMENT ON COLUMN public.re_object.state IS 'state – состояние объекта * Может принимать значения:
1.	Подготовка (ввод данных, не заполнены все ОБЯЗАТЕНЛЬНЫЕ параметры, не виден никому кроме агента его продающего), published=false
2.	Опубликован (все ок, виден всем участникам, участвует во всех процессах),  published=true
3.	Снят с продажи (виден всем участникам, только при указании этого состояния в фильтре) , published=false
4.	Продан (виден всем участникам, только при указании этого состояния в фильтре) , published=false';
COMMENT ON COLUMN public.re_object.area_gen IS 'Общая площадь';
COMMENT ON COLUMN public.re_object.area_res IS 'Жилая площадь';
COMMENT ON COLUMN public.re_object.measure_id IS 'Ссылка на единицу измерения площади (measure_au)';


CREATE OR REPLACE VIEW public.v_re_object AS
select 

o.*,
tt.name as transaction_type_name,
c.name as category_name,
ct.city as city_name,
cta.name as cityarea_name,
cr.short_name as currency,
o.price / o.area_res as price_for_sqm

from re_object as o
inner join transaction_types as tt on (o.transaction_type = tt.type_code)
inner join re_category as c on (o.category_id = c.id AND c.parent != 0) -- не может быть выбрана корневая категория
inner join geo_city as ct on (o.city_id = ct.id)
inner join geo_cityarea as cta on (o.cityarea_id = cta.id)
inner join currency as cr on (o.currency_id = cr.id);
ALTER TABLE public.v_re_object
  OWNER TO mvv_user;


ALTER TABLE param_data_types
   ADD COLUMN validator_regexp character varying(128);
COMMENT ON COLUMN param_data_types.validator_regexp
  IS 'Regular expression for dynamic validation';


TRUNCATE TABLE param_data_types;

INSERT INTO param_data_types(data_type_id, symbol, descr, min_values_count, zend_element_name, validator_regexp) 
VALUES 
    (1, 'I', 'Integer', NULL, 'text', '^\d{1,}$'), 
    (2, 'R', 'Real', NULL, 'text', '^\d{1,}(\.\d{0,2}){0,1}$'),
    (3, 'D', 'Date', NULL, 'text', '^\d{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[0-1])$'),
    (4, 'S', 'String', NULL, 'text', ''),
    (5, 'CB', 'CheckBox', 1, 'multicheckbox', ''),
    (6, 'RB', 'RadioButton', 2, 'radio', ''),
    (7, 'L', 'List', 2, 'select', '');


DROP VIEW IF EXISTS v_param_wtypes;

CREATE OR REPLACE VIEW v_param_wtypes AS 
 select 
 	p.*, 
 	pt.symbol as data_type_symbol,
 	pt.validator_regexp

    from param as p
    join param_data_types as pt on p.data_type = pt.data_type_id;

ALTER TABLE v_param_wtypes
  OWNER TO mvv_user;



DROP VIEW IF EXISTS v_params_set;

CREATE OR REPLACE VIEW v_params_set AS 
 SELECT 
    p.id, 
    p.category_id, 
    rc.parent as parent_category_id, 
    p.param_name_field, p.label,
    p.description,
    p.label_is_show,
    p.data_type,
    p.published,
    p.in_search,
    p.sort_order,
    pt.symbol,
    pt.descr,
    pt.min_values_count,
    pt.zend_element_name,
    pt.validator_regexp
   FROM param p
   JOIN param_data_types pt ON p.data_type = pt.data_type_id
   JOIN re_category as rc ON rc.id = p.category_id
  WHERE p.published = true
  ORDER BY p.sort_order;

ALTER TABLE v_params_set
  OWNER TO mvv_user;


ALTER TABLE re_object_pset_mono DROP COLUMN value_real;
ALTER TABLE re_object_pset_mono DROP COLUMN value_integer;
ALTER TABLE re_object_pset_mono DROP COLUMN value_data;

ALTER TABLE re_object_pset_mono ADD COLUMN _value varchar(1000);
ALTER TABLE re_object_pset_mono
  OWNER TO mvv_user;


ALTER TABLE re_object_pset_mono
ADD CONSTRAINT param_id_fkey
    FOREIGN KEY (param_id)
    REFERENCES param(id)
    ON DELETE CASCADE;

ALTER TABLE re_object_pset_mono
ADD CONSTRAINT re_object_id_fkey
    FOREIGN KEY (object_id)
    REFERENCES re_object(id)
    ON DELETE NO ACTION;


ALTER TABLE re_object_pset_multi
ADD CONSTRAINT re_object_id_fkey
    FOREIGN KEY (object_id)
    REFERENCES re_object(id)
    ON DELETE NO ACTION;

ALTER TABLE re_object_pset_multi
ADD CONSTRAINT param_id_fkey
    FOREIGN KEY (param_id)
    REFERENCES param(id)
    ON DELETE CASCADE;

ALTER TABLE re_object_pset_multi
DROP COLUMN cheked_id,
ADD COLUMN checked_id integer NOT NULL;

ALTER TABLE re_object_pset_multi
ADD CONSTRAINT param_multivalue_id_fkey
    FOREIGN KEY (checked_id)
    REFERENCES param_multivalue(id)
    ON DELETE CASCADE;