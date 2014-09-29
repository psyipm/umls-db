-- Tasks #1743


CREATE SEQUENCE "public"."param_id_seq"
 INCREMENT 1
 NO MINVALUE
 NO MAXVALUE
 START 1
 CACHE 1
 OWNED BY "public"."param"."id";

ALTER TABLE "public"."param_id_seq" OWNER TO "mvv_user";


ALTER TABLE "public"."param"
ALTER COLUMN "id" SET DEFAULT nextval('param_id_seq'::regclass),
ADD PRIMARY KEY ("id");

ALTER TABLE "public"."param"
ALTER COLUMN "sort_order" SET DEFAULT 0;


CREATE TABLE "public"."param_multivalue" (
"id" int4 NOT NULL,
"param_id" int4 NOT NULL,
"multivalue" varchar(128) NOT NULL,
"sort_order" int4 NOT NULL,
PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

COMMENT ON COLUMN "public"."param_multivalue"."param_id" IS 'ссылка на параметр (table "param")';

COMMENT ON COLUMN "public"."param_multivalue"."multivalue" IS 'значение для набора данных, для мультиязычных параметров';

COMMENT ON COLUMN "public"."param_multivalue"."sort_order" IS 'порядок отображения в группе';


CREATE SEQUENCE "public"."param_multivalue_id_seq"
 INCREMENT 1
 START 1
 CACHE 1
 OWNED BY "public"."param_multivalue"."id";

ALTER TABLE "public"."param_multivalue_id_seq" OWNER TO "mvv_user";


ALTER TABLE "public"."param_multivalue"
ALTER COLUMN "id" SET DEFAULT nextval('param_multivalue_id_seq'::regclass);


CREATE TABLE "public"."param_data_types" (
"id" int4 NOT NULL,
"data_type_id" int4 NOT NULL,
"symbol" varchar(5) NOT NULL,
"descr" varchar(128) NOT NULL,
"min_values_count" int4,
PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

COMMENT ON COLUMN "public"."param_data_types"."data_type_id" IS 'id типа данных';
COMMENT ON COLUMN "public"."param_data_types"."symbol" IS 'короткое обозначение типа данных';
COMMENT ON COLUMN "public"."param_data_types"."descr" IS 'полное название типа данных';
COMMENT ON COLUMN "public"."param_data_types"."min_values_count" IS 'минимальное количество значений';


CREATE SEQUENCE "public"."param_data_types_id_seq"
 INCREMENT 1
 START 1
 CACHE 1
 OWNED BY "public"."param_data_types"."id";

ALTER TABLE "public"."param_data_types_id_seq" OWNER TO "mvv_user";


ALTER TABLE "public"."param_data_types"
ALTER COLUMN "id" SET DEFAULT nextval('param_data_types_id_seq'::regclass);

INSERT INTO "param_data_types" VALUES (1, 1, 'I', 'Integer', NULL);
INSERT INTO "param_data_types" VALUES (2, 2, 'R', 'Real', NULL);
INSERT INTO "param_data_types" VALUES (3, 3, 'D', 'Date', NULL);
INSERT INTO "param_data_types" VALUES (4, 4, 'S', 'String', NULL);
INSERT INTO "param_data_types" VALUES (5, 5, 'CHb', 'CheckBox', 1);
INSERT INTO "param_data_types" VALUES (6, 6, 'RDb', 'RadioButton', 2);
INSERT INTO "param_data_types" VALUES (7, 7, 'L', 'List', 2);

CREATE VIEW "public"."v_param" AS 
select 
	p.*, 
	pc."name" as category_name 
from "public".param as p
inner join "public".param_category as pc on (p.id = pc.id);
