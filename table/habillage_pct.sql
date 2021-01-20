CREATE TABLE plui.habillage_pct
(
    nattrac character(40) COLLATE pg_catalog."default" NOT NULL,
    idurba character varying(30) COLLATE pg_catalog."default" NOT NULL,
    idkey integer NOT NULL DEFAULT nextval('plui.habillage_pct_idkey_seq'::regclass),
    the_geom geometry(Point,2154),
    couleur character varying(11) COLLATE pg_catalog."default",
    CONSTRAINT habillage_pct_pkey PRIMARY KEY (idkey)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.habillage_pct
    OWNER to postgres;

GRANT ALL ON TABLE plui.habillage_pct TO postgres;
-- Index: habillage_pct_geom_gist

-- DROP INDEX plui.habillage_pct_geom_gist;

CREATE INDEX habillage_pct_geom_gist
    ON plui.habillage_pct USING gist
    (the_geom)
    TABLESPACE pg_default;
