-- Tasks #1

CREATE TABLE public.re_object_doc (
id SERIAL,
object_id INTEGER NOT NULL,
path_to_file VARCHAR(255) NOT NULL,
info VARCHAR(255),
CONSTRAINT re_object_doc_pkey PRIMARY KEY(id))
WITH (oids = false);
COMMENT ON COLUMN public.re_object_doc.object_id
IS 'ссылка на объект которому принадлежит элемент галереи';
COMMENT ON COLUMN public.re_object_doc.path_to_file
IS 'путь к файлу';
COMMENT ON COLUMN public.re_object_doc.info
IS 'Описание файла';


-- fix misspeled sequence name
ALTER SEQUENCE geo_region_ig_seq
  RENAME TO geo_region_id_seq;


