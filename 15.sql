-- Tasks #33


ALTER TABLE news
   ADD COLUMN title character varying(256) NOT NULL;
COMMENT ON COLUMN news.title
  IS 'Заголовок новости';

ALTER TABLE news
	DROP COLUMN rating;