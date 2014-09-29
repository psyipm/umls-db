-- Tasks #34

DROP TABLE IF EXISTS public.links;

-- Fixed misspelled column name 'discription'
CREATE TABLE public.links (
id SERIAL,
link_url VARCHAR NOT NULL,
description VARCHAR NOT NULL,
published BOOLEAN DEFAULT true NOT NULL,
CONSTRAINT links_pkey PRIMARY KEY(id))
WITH (oids = false);
ALTER TABLE public.links
ALTER COLUMN id SET STATISTICS 0;
COMMENT ON COLUMN public.links.link_url
IS 'ссылка';
COMMENT ON COLUMN public.links.description
IS 'Описание ссылки';