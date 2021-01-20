CREATE TABLE plui.info_lin
(
    libelle character varying(254) COLLATE pg_catalog."default" NOT NULL,
    txt character varying(10) COLLATE pg_catalog."default",
    typeinf character(2) COLLATE pg_catalog."default" NOT NULL,
    stypeinf character(2) COLLATE pg_catalog."default" NOT NULL,
    nomfic character varying(80) COLLATE pg_catalog."default",
    urlfic character varying(254) COLLATE pg_catalog."default",
    datvalid date,
    idkey integer NOT NULL DEFAULT nextval('plui.info_lin_idkey_seq'::regclass),
    the_geom geometry(MultiLineString,2154),
    CONSTRAINT info_lin_pkey PRIMARY KEY (idkey)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.info_lin
    OWNER to postgres;

GRANT ALL ON TABLE plui.info_lin TO postgres;
-- Index: info_lin_geom_gist

-- DROP INDEX plui.info_lin_geom_gist;

CREATE INDEX info_lin_geom_gist
    ON plui.info_lin USING gist
    (the_geom)
    TABLESPACE pg_default;
