-- Tasks #186


DROP VIEW v_agent_info;

CREATE OR REPLACE VIEW v_agent_info AS 

 SELECT a.id,
    a.name_f,
    a.name_n,
    a.name_o,
    a.agency_id,
    a.user_id,
    a.skype,
    a.viber,
    a.site,
    a.city_id,
    a.address,
    a.country_id,
    a.region_id,
    a.photo,
    u.email,
    u.active,
    u.name,
    ( SELECT array_to_string(array_prepend(u.phone, array_agg(p.phone)), '||'::text) AS array_to_string
           FROM agents_phones p
          WHERE p.agent_id = a.id) AS phones
   FROM agents a
     JOIN users u ON u.id = a.user_id;


insert into permissions(permission, descr)
values('user-interface\members', 'Доступ к разделу "Участники"');