-- Tasks #125


create view v_msg_inbox_new as

SELECT count(*) AS inbox_new
           FROM msg_received
          WHERE msg_received.recipient_id = (( SELECT get_var('user_id'::character varying)::integer AS get_var)) AND msg_received.state = 1 AND msg_received.category <> 1;
