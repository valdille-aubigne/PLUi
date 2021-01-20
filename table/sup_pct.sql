-- Table: plui.sup_pct

-- DROP TABLE plui.sup_pct;

CREATE TABLE plui.sup_pct
(
    idkey integer NOT NULL DEFAULT nextval('plui.sup_pct_idkey_seq'::regclass),
    libsup character varying(250) COLLATE pg_catalog."default",
    categorie character varying(6) COLLATE pg_catalog."default",
    infos character varying(254) COLLATE pg_catalog."default",
    regles character varying(100) COLLATE pg_catalog."default",
    datappro character varying(14) COLLATE pg_catalog."default",
    nomfic character varying(80) COLLATE pg_catalog."default",
    urlfic character varying(254) COLLATE pg_catalog."default",
    datvalid character varying(14) COLLATE pg_catalog."default",
    the_geom geometry(Point,2154),
    CONSTRAINT sup_pct_pkey PRIMARY KEY (idkey)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.sup_pct
    OWNER to postgres;

GRANT ALL ON TABLE plui.sup_pct TO postgres;
