-- Tasks #1658


CREATE TABLE "public"."user_remember_me" (
"sid" varchar(16) NOT NULL,
"token" varchar(16) NOT NULL,
"user_id" int4 NOT NULL,
CONSTRAINT "user_remember_me" FOREIGN KEY ("user_id") REFERENCES "public"."users" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT "sid" UNIQUE ("sid", "token", "user_id")
)
WITH (OIDS=FALSE)
;
