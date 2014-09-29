-- Tasks #1739


DROP TABLE "public"."param";
CREATE TABLE "public"."param" (
    id integer NOT NULL,
    category_id integer NOT NULL,
    param_name_field character varying(128) NOT NULL,
    label character varying(128) NOT NULL,
    description character varying(512),
    label_is_show boolean DEFAULT true NOT NULL,
    data_type integer DEFAULT 1 NOT NULL,
    published boolean DEFAULT true NOT NULL,
    in_search boolean DEFAULT true NOT NULL,
    sort_order integer NOT NULL
);
ALTER TABLE ONLY param ALTER COLUMN param_name_field SET STATISTICS 0;
ALTER TABLE ONLY param ALTER COLUMN label SET STATISTICS 0;
ALTER TABLE ONLY param ALTER COLUMN description SET STATISTICS 0;
ALTER TABLE ONLY param ALTER COLUMN label_is_show SET STATISTICS 0;
ALTER TABLE ONLY param ALTER COLUMN data_type SET STATISTICS 0;
ALTER TABLE ONLY param ALTER COLUMN in_search SET STATISTICS 0;

--
-- TOC entry 2392 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN param.category_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN param.category_id IS 'ссылка на категорию';


--
-- TOC entry 2393 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN param.param_name_field; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN param.param_name_field IS 'наименование параметра (на англ)';


--
-- TOC entry 2394 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN param.label; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN param.label IS 'заголовок параметра';


--
-- TOC entry 2395 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN param.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN param.description IS 'Подсказка к параметру, отображается в хинте, при наведении курсора на параметр';


--
-- TOC entry 2396 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN param.label_is_show; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN param.label_is_show IS 'отображать заголовок параметра';


--
-- TOC entry 2397 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN param.data_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN param.data_type IS 'тип параметра: 1- целое (I), 2-десятичное (R), 3-строка (S),4- дата (D), 5-чек-бокс (CHb, минимум 1 значение, произвольный выбор), 6-радиокнопка (RDb, минимум 2 значения, выбор только 1 значения), 7-список (L), минимум 2 значения, выбор только одного';


--
-- TOC entry 2398 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN param.published; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN param.published IS 'параметр опубликован ?)';


--
-- TOC entry 2399 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN param.in_search; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN param.in_search IS 'параметр используется в поиске?';


--
-- TOC entry 2400 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN param.sort_order; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN param.sort_order IS 'порядок отображения в рамках категории';



--
-- TOC entry 224 (class 1259 OID 25597)
-- Name: re_cparam_set; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--
DROP TABLE re_cparam_set;
CREATE TABLE re_cparam_set (
    id integer NOT NULL,
    category_id integer NOT NULL,
    param_id integer NOT NULL,
    param_field_name character varying(128) NOT NULL,
    value_o boolean DEFAULT false NOT NULL,
    value_d boolean DEFAULT false NOT NULL,
    value_a integer DEFAULT 0 NOT NULL,
    value_tab boolean DEFAULT false NOT NULL,
    value_tile boolean DEFAULT false NOT NULL
);

--
-- TOC entry 2416 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN re_cparam_set.category_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_cparam_set.category_id IS 'ссылка на категорию';


--
-- TOC entry 2417 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN re_cparam_set.param_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_cparam_set.param_id IS 'ссылка на id параметра';


--
-- TOC entry 2418 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN re_cparam_set.param_field_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN re_cparam_set.param_field_name IS 'название параметра (filed name)';


--
-- TOC entry 223 (class 1259 OID 25595)
-- Name: re_cparam_set_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE re_cparam_set_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.re_cparam_set_id_seq OWNER TO postgres;

--
-- TOC entry 2419 (class 0 OID 0)
-- Dependencies: 223
-- Name: re_cparam_set_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE re_cparam_set_id_seq OWNED BY re_cparam_set.id;



CREATE VIEW "public"."v_re_cparam_set" AS 
select 
ps.*,
pc.name as params_category,
p.param_name_field,
p.data_type as param_type,
p.sort_order
from re_cparam_set ps
inner join param_category as pc on (pc.id = ps.category_id)
inner join param as p on (p.id = ps.param_id);
