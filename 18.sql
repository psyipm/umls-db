-- Tasks #45


DROP VIEW v_ulog_last_failed;

CREATE OR REPLACE VIEW v_ulog_last_failed AS 
 SELECT ulog.id,
    ulog.user_id,
    ulog.action_dt,
    ulog.ip_addr,
    ulog.platform,
    ulog.type_act,
    ulog.comments
   FROM ulog
  WHERE ulog.action_dt >= (CURRENT_TIMESTAMP AT TIME ZONE 'UTC' - '00:30:00'::interval) AND ulog.comments::text = 'Unsuccessfully'::text;


CREATE VIEW v_ulog AS
 SELECT * FROM ulog

ORDER BY id DESC;