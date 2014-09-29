DROP VIEW IF EXISTS v_re_object;
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
    price money NOT NULL,
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

DROP VIEW IF EXISTS public.v_re_object;
CREATE OR REPLACE VIEW public.v_re_object AS
select 

o.id,
tt.name as transaction_type_name,
o.transaction_type,
c.name as category_name,
o.category_id,
o.country_id,
o.region_id,
ct.city as city_name,
o.city_id,
cta.name as cityarea_name,
o.cityarea_id,
o.street,
o.price,
cr.short_name as currency,
o.currency_id,
o.data_unact,
o.area_gen,
o.area_res,
o.price / o.area_res as price_for_sqm,
o.published

from re_object as o
inner join transaction_types as tt on (o.transaction_type = tt.type_code)
inner join re_category as c on (o.category_id = c.id AND c.parent != 0) -- не может быть выбрана корневая категория
inner join geo_city as ct on (o.city_id = ct.id)
inner join geo_cityarea as cta on (o.cityarea_id = cta.id)
inner join currency as cr on (o.currency_id = cr.id);
ALTER TABLE public.v_re_object
  OWNER TO mvv_user;


ALTER TABLE ONLY public.re_category ADD COLUMN measure_id integer DEFAULT 1 NOT NULL;

--
-- Structure for table measure_au (OID = 25728) : 
--
CREATE TABLE public.measure_au (
    id serial NOT NULL,
    name varchar(12) NOT NULL
)
WITH (oids = false);
--
-- Structure for table re_object_pset_mono (OID = 25739) : 
--
CREATE TABLE public.re_object_pset_mono (
    id serial NOT NULL,
    object_id integer NOT NULL,
    param_id integer NOT NULL,
    value_data date,
    value_integer integer,
    value_real numeric(16,2)
)
WITH (oids = false);
--
-- Structure for table re_object_pset_multi (OID = 25747) : 
--
CREATE TABLE public.re_object_pset_multi (
    id serial NOT NULL,
    object_id integer NOT NULL,
    param_id integer NOT NULL,
    cheked_id integer NOT NULL
)
WITH (oids = false);
--
-- Data for table public.measure_au (OID = 25728) (LIMIT 0,3)
--
INSERT INTO measure_au (id, name)
VALUES (1, 'кв.м.');

INSERT INTO measure_au (id, name)
VALUES (2, 'сотка(и)');

INSERT INTO measure_au (id, name)
VALUES (3, 'га.');


-- Definition for index ra_object_pkey (OID = 25654) : 
--
ALTER TABLE ONLY re_object
    ADD CONSTRAINT ra_object_pkey
    PRIMARY KEY (id);
--
-- Definition for index au_measure_pkey (OID = 25732) : 
--
ALTER TABLE ONLY measure_au
    ADD CONSTRAINT au_measure_pkey
    PRIMARY KEY (id);
--
-- Definition for index au_measure_name_key (OID = 25734) : 
--
ALTER TABLE ONLY measure_au
    ADD CONSTRAINT au_measure_name_key
    UNIQUE (name);
--
-- Definition for index re_object_pset_mono_pkey (OID = 25743) : 
--
ALTER TABLE ONLY re_object_pset_mono
    ADD CONSTRAINT re_object_pset_mono_pkey
    PRIMARY KEY (id);
--
-- Definition for index re_object_pset_multi_pkey (OID = 25751) : 
--
ALTER TABLE ONLY re_object_pset_multi
    ADD CONSTRAINT re_object_pset_multi_pkey
    PRIMARY KEY (id);
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
COMMENT ON COLUMN public.measure_au.name IS 'краткое название единицы измерения';
COMMENT ON TABLE public.re_object_pset_mono IS 'Таблица';
COMMENT ON COLUMN public.re_object_pset_mono.object_id IS 'ссылка на объект';
COMMENT ON COLUMN public.re_object_pset_mono.param_id IS 'ссылка на монопараметр';
COMMENT ON COLUMN public.re_object_pset_mono.value_data IS 'значение дата';
COMMENT ON COLUMN public.re_object_pset_mono.value_integer IS 'целое значение';
COMMENT ON COLUMN public.re_object_pset_mono.value_real IS 'вещественное значение';
COMMENT ON COLUMN public.re_object_pset_multi.object_id IS 'ссылка на объект';
COMMENT ON COLUMN public.re_object_pset_multi.param_id IS 'ссылка на параметр';
COMMENT ON COLUMN public.re_object_pset_multi.cheked_id IS 'выбранный элемент из списка элементов (param_multivalue, id )';



DROP VIEW IF EXISTS v_params_set;

CREATE OR REPLACE VIEW v_params_set AS 
 SELECT p.id, p.category_id, rc.parent as parent_category_id, p.param_name_field, p.label, p.description, p.label_is_show, p.data_type, p.published, p.in_search, p.sort_order, pt.symbol, pt.descr, pt.min_values_count, pt.zend_element_name
   FROM param p
   JOIN param_data_types pt ON p.data_type = pt.data_type_id
   JOIN re_category as rc ON rc.id = p.category_id
  WHERE p.published = true
  ORDER BY p.sort_order;

ALTER TABLE v_params_set
  OWNER TO mvv_user;


ALTER TABLE param_data_types
   ADD COLUMN zend_element_name character varying(32) NOT NULL DEFAULT 'text';
COMMENT ON COLUMN param_data_types.zend_element_name
  IS 'Zend element name';

TRUNCATE TABLE param_data_types;

INSERT INTO param_data_types(data_type_id, symbol, descr, min_values_count, zend_element_name) 
VALUES 
    (1, 'I', 'Integer', NULL, 'text'), 
    (2, 'R', 'Real', NULL, 'text'),
    (3, 'D', 'Date', NULL, 'text'),
    (4, 'S', 'String', NULL, 'text'),
    (5, 'CB', 'CheckBox', 1, 'multicheckbox'),
    (6, 'RB', 'RadioButton', 2, 'radio'),
    (7, 'L', 'List', 2, 'select');


CREATE OR REPLACE VIEW v_param_wtypes AS 
 select p.*, pt.symbol as data_type_symbol
    from param as p
    join param_data_types as pt on p.data_type = pt.data_type_id;

ALTER TABLE v_param_wtypes
  OWNER TO mvv_user;


CREATE TABLE public.re_object_gal (
id SERIAL,
object_id INTEGER NOT NULL,
path_to_file VARCHAR(255) NOT NULL,
info VARCHAR(255),
"order" INTEGER DEFAULT 1 NOT NULL,
CONSTRAINT re_object_gal_pkey PRIMARY KEY(id))
WITH (oids = false);
ALTER TABLE public.re_object_gal
ALTER COLUMN "order" SET STATISTICS 0;
COMMENT ON COLUMN public.re_object_gal.object_id
IS 'ссылка на объект которому принадлежит элемент галереи';
COMMENT ON COLUMN public.re_object_gal.path_to_file
IS 'путь к файлу изображения';
COMMENT ON COLUMN public.re_object_gal.info
IS 'Описание к фото';
COMMENT ON COLUMN public.re_object_gal."order"
IS 'порядок следования в галерее обекта';


ALTER TABLE re_object_gal RENAME "order"  TO sort_order;


