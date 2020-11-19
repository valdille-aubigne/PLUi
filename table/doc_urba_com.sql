-- Table: plui.doc_urba_com

-- DROP TABLE plui.doc_urba_com;

CREATE TABLE plui.doc_urba_com
(
    insee character(5) COLLATE pg_catalog."default",
    idurba character varying(30) COLLATE pg_catalog."default",
    the_geom geometry(Geometry,2154)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.doc_urba_com
    OWNER to postgres;

GRANT ALL ON TABLE plui.doc_urba_com TO postgres;
-- Index: doc_urba_com_the_geom_1553528316973

-- DROP INDEX plui.doc_urba_com_the_geom_1553528316973;

CREATE INDEX doc_urba_com_the_geom_1553528316973
    ON plui.doc_urba_com USING gist
    (the_geom)
    TABLESPACE pg_default;
