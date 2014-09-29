-- Tasks #1649

create view v_ulog_last_failed as
SELECT * FROM "public"."ulog" where action_dt >= now() - INTERVAL '30 minutes' and comments = 'Unsuccessfully';