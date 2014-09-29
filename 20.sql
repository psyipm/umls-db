-- Tasks  #67


create view "v_members_objects_count" as 
SELECT  (
        SELECT COUNT(*)
        FROM   users
        ) AS members,
        (
        SELECT COUNT(*)
        FROM   re_object
        ) AS objects
;