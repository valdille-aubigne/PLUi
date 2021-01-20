CREATE TABLE plui.info_pct
(
    libelle character varying(254) COLLATE pg_catalog."default" NOT NULL,
    txt character varying(10) COLLATE pg_catalog."default",
    typeinf character(2) COLLATE pg_catalog."default" NOT NULL,
    stypeinf character(2) COLLATE pg_catalog."default" NOT NULL,
    nomfic character varying(80) COLLATE pg_catalog."default",
    urlfic character varying(254) COLLATE pg_catalog."default",
    datvalid date,
    idkey integer NOT NULL DEFAULT nextval('plui.info_pct_idkey_seq'::regclass),
    the_geom geometry(Point,2154),
    CONSTRAINT info_pct_pkey PRIMARY KEY (idkey)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.info_pct
    OWNER to postgres;

GRANT ALL ON TABLE plui.info_pct TO postgres;
-- Index: info_pct_geom_gist

-- DROP INDEX plui.info_pct_geom_gist;

CREATE INDEX info_pct_geom_gist
    ON plui.info_pct USING gist
    (the_geom)
    TABLESPACE pg_default;
