-- Tasks #1697


DROP TABLE re_category;
CREATE TABLE re_category (
    id integer NOT NULL,
    parent_id integer NOT NULL,
    name character varying(128) NOT NULL,
    info character varying(255) NOT NULL,
    published boolean DEFAULT true NOT NULL,
    "sort_order" integer NOT NULL,
    category_image character varying(255)
);
ALTER TABLE ONLY re_category ALTER COLUMN id SET STATISTICS 0;

--
-- TOC entry 2409 (class 0 OID 0)
-- Dependencies: 213
-- Name: TABLE re_category; Type: COMMENT; Schema: public; Owner: mvv_user
--

COMMENT ON TABLE re_category IS 'Справочник категорий объектов (дерево)';


--
-- TOC entry 2410 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN re_category.parent_id; Type: COMMENT; Schema: public; Owner: mvv_user
--

COMMENT ON COLUMN re_category.parent_id IS 'ссылка на материнскую категорию';


--
-- TOC entry 2411 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN re_category.name; Type: COMMENT; Schema: public; Owner: mvv_user
--

COMMENT ON COLUMN re_category.name IS 'наименование категории';


--
-- TOC entry 2412 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN re_category.info; Type: COMMENT; Schema: public; Owner: mvv_user
--

COMMENT ON COLUMN re_category.info IS 'описание категории';


--
-- TOC entry 2413 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN re_category."sort_order"; Type: COMMENT; Schema: public; Owner: mvv_user
--

COMMENT ON COLUMN re_category."sort_order" IS 'порядок в категории';


--
-- TOC entry 2414 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN re_category.category_image; Type: COMMENT; Schema: public; Owner: mvv_user
--

COMMENT ON COLUMN re_category.category_image IS 'ссылка на файл с изображением для категории';


--
-- TOC entry 212 (class 1259 OID 25524)
-- Name: re_category_id_seq; Type: SEQUENCE; Schema: public; Owner: mvv_user
--

CREATE SEQUENCE re_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- TOC entry 2415 (class 0 OID 0)
-- Dependencies: 212
-- Name: re_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mvv_user
--

ALTER SEQUENCE re_category_id_seq OWNED BY re_category.id;


ALTER TABLE "public"."re_category"
ALTER COLUMN "id" SET DEFAULT nextval('re_category_id_seq'::regclass),
ADD PRIMARY KEY ("id");

ALTER TABLE "public"."re_category" RENAME "parent_id" TO "parent";
