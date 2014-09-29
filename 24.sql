CREATE FUNCTION public.new_param_add (
)
RETURNS trigger
AS 
$body$
DECLARE
  category_cur CURSOR FOR select id from re_category ;
  cat_id integer;
BEGIN

/*при создании нового параметра  - добавляем его в наборов параметров*/

INSERT INTO re_cparam_set
(
  category_id,
  param_id,
  value_o,
  value_d,
  value_a,
  value_tab,
  value_tile
)
VALUES (
  NEW.category_id,
  NEW.id,
  false,
  false,
  0,
  false,
  false
);

return NEW;

END;
$body$
LANGUAGE plpgsql;


CREATE TRIGGER tr_param
    AFTER INSERT ON param
    FOR EACH ROW
    EXECUTE PROCEDURE new_param_add ();