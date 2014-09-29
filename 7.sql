-- Tasks #1698

DROP TABLE "public"."param_category";
CREATE TABLE "public"."param_category" (
"id" SERIAL,
"name" VARCHAR NOT NULL,
"published" BOOLEAN NOT NULL DEFAULT true,
"access" INTEGER NOT NULL DEFAULT 0,
"sort_order" INTEGER NOT NULL);