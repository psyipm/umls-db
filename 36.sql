-- Tasks #119


CREATE TABLE public.favorites (
id SERIAL,
user_id INTEGER NOT NULL,
object_id INTEGER NOT NULL,
date_add DATE NOT NULL,
CONSTRAINT favorites_pkey PRIMARY KEY(id))
WITH (oids = false);
ALTER TABLE public.favorites
ALTER COLUMN object_id SET STATISTICS 0;
ALTER TABLE public.favorites
ALTER COLUMN date_add SET STATISTICS 0;
COMMENT ON COLUMN public.favorites.user_id
IS 'ссылка на пользователя';
COMMENT ON COLUMN public.favorites.object_id
IS 'ссылка на объект';
COMMENT ON COLUMN public.favorites.date_add
IS 'дата добавления в избранное';


ALTER TABLE favorites ALTER COLUMN date_add
SET DEFAULT CURRENT_DATE;


create view v_my_favorite_objects as

select o.* from favorites f
join v_my_objects o on (o.id = f.object_id)
where f.user_id = (select cast(get_var('user_id') as integer));