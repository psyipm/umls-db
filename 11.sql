CREATE TABLE re_object (
    id integer NOT NULL,
    transaction_type integer NOT NULL,
    category_id integer NOT NULL,
    country_id integer DEFAULT 0 NOT NULL,
    region_id integer DEFAULT 0 NOT NULL,
    city_id integer NOT NULL,
    cityarea_id integer DEFAULT 0 NOT NULL,
    geo_lat double precision,
    geo_long double precision,
    street character varying(255) NOT NULL,
    build character varying(12) NOT NULL,
    price money NOT NULL,
    currency_id integer NOT NULL,
    price_for integer DEFAULT 0 NOT NULL,
    reff character varying(12),
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
    meta_keyword character varying(255),
    meta_description character varying(200),
    meta_title character varying(80),
    tags character varying(255),
    info_short character varying(1000) NOT NULL,
    info_full character varying NOT NULL,
    video_link character varying(255),
    state integer DEFAULT 0 NOT NULL
);
ALTER TABLE ONLY re_object ALTER COLUMN id SET STATISTICS 0;
ALTER TABLE ONLY re_object ALTER COLUMN city_id SET STATISTICS 0;


ALTER TABLE public.re_object OWNER TO postgres;

--
-- TOC entry 2420 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE re_object; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE re_object IS 'Справочник объектов';


--
-- TOC entry 2421 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.transaction_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.transaction_type IS 'тип сделки по объекту 0-продажа, 1-аренда';


--
-- TOC entry 2422 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.category_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.category_id IS 'категория объекта, из справочника категорий. Не может быть выбрана «узловая категория», т.е. категория у которой существуют подкатегории';


--
-- TOC entry 2423 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.country_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.country_id IS 'Страна';


--
-- TOC entry 2424 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.region_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.region_id IS 'область';


--
-- TOC entry 2425 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.city_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.city_id IS 'Населенный пункт объекта, или ближайший к объекту населенный пункт';


--
-- TOC entry 2426 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.cityarea_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.cityarea_id IS 'Ссылка на район населенного пункта';


--
-- TOC entry 2427 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.geo_lat; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.geo_lat IS 'Широта, в десятичных градусах';


--
-- TOC entry 2428 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.geo_long; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.geo_long IS 'Долгота, в десятичных градусах';


--
-- TOC entry 2429 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.street; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.street IS 'улица объекта прописью *';


--
-- TOC entry 2430 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.build; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.build IS 'build – номер здания *';


--
-- TOC entry 2431 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.price; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.price IS 'цена объекта. Для продажи цена в выбранной валюте, для аренды цена аренды за период (на выбор: Сутки/Неделя/Месяц/Квартал/Полугодие/Год)';


--
-- TOC entry 2432 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.currency_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.currency_id IS 'currency_id – валюта цены (выбирается из справочника валют)';


--
-- TOC entry 2433 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.price_for; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.price_for IS 'Цена за
0 - за объект (если родажа)
1 - за сутки (если аренда)
2 - за неделю (если аренда)
3 - за месяц (если аренда)
4 - за квартал (если аренда)
5 - за полугодие (если аренда)
6 - за год (если аренда)';


--
-- TOC entry 2434 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.reff; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.reff IS 'Реферальный номер';


--
-- TOC entry 2435 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.agent_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.agent_id IS 'Агент, владелец объекта';


--
-- TOC entry 2436 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.data_create; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.data_create IS 'Дата создания объекта';


--
-- TOC entry 2437 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.data_renew; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.data_renew IS 'Дата последнего обновления объекта';


--
-- TOC entry 2438 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.data_action; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.data_action IS 'Дата отметки "Акция"';


--
-- TOC entry 2439 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.data_unact; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.data_unact IS 'Дата автоматического снятия с публикации';


--
-- TOC entry 2440 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.data_sold; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.data_sold IS 'data_sold – дата продажи объекта (если сделка по объекту закончилась продажей)';


--
-- TOC entry 2441 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.data_del; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.data_del IS 'data_del – дата удаления объекта из системы  (для пользователя системы не отображается, доступен только суперадминистратору)';


--
-- TOC entry 2442 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.is_del; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.is_del IS 'Объект удален ?';


--
-- TOC entry 2443 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.is_umls_user; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.is_umls_user IS 'Укзатель того что объект принадлежит пользователю UMLS';


--
-- TOC entry 2444 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.published; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.published IS 'Объект опубликован ?';


--
-- TOC entry 2445 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.count_view; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.count_view IS 'count_view – счетчик показов объекта * (для пользователя системы только для чтения, доступен полностью только суперадминистратору)';


--
-- TOC entry 2446 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.meta_keyword; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.meta_keyword IS 'meta_keyword – ключевые слова (<meta name="keywords" content=" " /> на странице объекта) *';


--
-- TOC entry 2447 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.meta_description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.meta_description IS 'meta_description – ключевая информация (  <meta name="description" content=" " /> на странице объекта) *';


--
-- TOC entry 2448 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.meta_title; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.meta_title IS 'meta_title – ключевая информация (  <meta name="title" content=" " /> на странице объекта) *';


--
-- TOC entry 2449 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.tags; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.tags IS 'tags – теги объекта';


--
-- TOC entry 2450 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.info_short; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.info_short IS 'info_short – краткое описание объекта (простой текст) *';


--
-- TOC entry 2451 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.info_full; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.info_full IS 'info_full – полное описание объекта (html) *';


--
-- TOC entry 2452 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.video_link; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.video_link IS 'video_link – код для вставки видео';


--
-- TOC entry 2453 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN re_object.state; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_object.state IS 'state – состояние объекта * Может принимать значения:
1.	Подготовка (ввод данных, не заполнены все ОБЯЗАТЕНЛЬНЫЕ параметры, не виден никому кроме агента его продающего), published=false
2.	Опубликован (все ок, виден всем участникам, участвует во всех процессах),  published=true
3.	Снят с продажи (виден всем участникам, только при указании этого состояния в фильтре) , published=false
4.	Продан (виден всем участникам, только при указании этого состояния в фильтре) , published=false';



CREATE SEQUENCE re_object_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.re_object_id_seq OWNER TO postgres;

--
-- TOC entry 2463 (class 0 OID 0)
-- Dependencies: 229
-- Name: re_object_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE re_object_id_seq OWNED BY re_object.id;



ALTER TABLE ONLY re_object ALTER COLUMN id SET DEFAULT nextval('re_object_id_seq'::regclass);


ALTER TABLE ONLY re_object
    ADD CONSTRAINT re_object_pkey PRIMARY KEY (id);



-- Table: transaction_types

-- DROP TABLE transaction_types;

CREATE TABLE transaction_types
(
  id serial NOT NULL,
  type_code integer, -- Код типа сделки
  name character varying(128) -- Название
)
WITH (
  OIDS=FALSE
);
ALTER TABLE transaction_types
  OWNER TO mvv_user;
GRANT ALL ON TABLE transaction_types TO public;
GRANT ALL ON TABLE transaction_types TO mvv_user;
COMMENT ON TABLE transaction_types
  IS 'Типы сделок';
COMMENT ON COLUMN transaction_types.type_code IS 'Код типа сделки';
COMMENT ON COLUMN transaction_types.name IS 'Название';

ALTER TABLE ONLY transaction_types ALTER COLUMN id SET DEFAULT nextval('transaction_types_id_seq'::regclass);


ALTER TABLE ONLY transaction_types
    ADD CONSTRAINT transaction_types_pkey PRIMARY KEY (id);


insert into transaction_types ("type_code", "name") values('0', 'Продажа'), ('1', 'Аренда');


-- Table: price_for

-- DROP TABLE price_for;

CREATE TABLE price_for
(
  id serial NOT NULL,
  code integer, -- Код обозначения
  name character varying(128), -- Название
  transaction_type_code integer, -- Тип сделки
  CONSTRAINT price_for_id_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE price_for
  OWNER TO mvv_user;
GRANT ALL ON TABLE price_for TO public;
GRANT ALL ON TABLE price_for TO mvv_user;
COMMENT ON COLUMN price_for.code IS 'Код обозначения';
COMMENT ON COLUMN price_for.name IS 'Название';
COMMENT ON COLUMN price_for.transaction_type_code IS 'Тип сделки';

ALTER TABLE ONLY price_for ALTER COLUMN id SET DEFAULT nextval('price_for_id_seq'::regclass);

INSERT INTO price_for("code", "name", "transaction_type_code") 
VALUES('0', 'Объект', '0'), ('1', 'Сутки', '1'), ('2', 'Неделя', '1'), ('3', 'Месяц', '1'), ('4', 'Квартал', '1'), ('5', 'Полугодие', '1'), ('6', 'Год', '1');


-- Table: object_states

-- DROP TABLE object_states;

CREATE TABLE object_states
(
  id serial NOT NULL,
  code integer, -- Код обозначения
  name character varying(128), -- Название
  CONSTRAINT object_states_id_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE object_states
  OWNER TO mvv_user;
GRANT ALL ON TABLE object_states TO public;
GRANT ALL ON TABLE object_states TO mvv_user;
COMMENT ON COLUMN object_states.code IS 'Код обозначения';
COMMENT ON COLUMN object_states.name IS 'Название';

ALTER TABLE ONLY object_states ALTER COLUMN id SET DEFAULT nextval('object_states_id_seq'::regclass);

INSERT INTO object_states("code", "name") 
VALUES('1', 'Подготовка'), ('2', 'Опубликован'), ('3', 'Снят с продажи'), ('4', 'Продан');



ALTER TABLE public.re_object
  ADD COLUMN area_gen NUMERIC(12,2) DEFAULT 1 NOT NULL;
COMMENT ON COLUMN public.re_object.area_gen
IS 'Общая площадь';
ALTER TABLE public.re_object
  ADD COLUMN area_res NUMERIC(12,2) DEFAULT 1 NOT NULL;
COMMENT ON COLUMN public.re_object.area_res
IS 'Жилая площадь';



CREATE OR REPLACE VIEW public.v_re_object AS
select 

o.id,
tt.name as transaction_type,
c.name as category_name,
o.category_id,
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