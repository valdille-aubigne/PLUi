CREATE TABLE plui.habillage_lin
(
    nattrac character(40) COLLATE pg_catalog."default" NOT NULL,
    idurba character varying(30) COLLATE pg_catalog."default" NOT NULL,
    idkey integer NOT NULL DEFAULT nextval('plui.habillage_lin_idkey_seq'::regclass),
    the_geom geometry(MultiLineString,2154),
    couleur character varying(11) COLLATE pg_catalog."default",
    CONSTRAINT habillage_lin_pkey PRIMARY KEY (idkey)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.habillage_lin
    OWNER to postgres;

GRANT ALL ON TABLE plui.habillage_lin TO postgres;
-- Index: habillage_lin_geom_gist

-- DROP INDEX plui.habillage_lin_geom_gist;

CREATE INDEX habillage_lin_geom_gist
    ON plui.habillage_lin USING gist
    (the_geom)
    TABLESPACE pg_default;
