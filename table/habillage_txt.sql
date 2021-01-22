CREATE TABLE plui.habillage_txt
(
    natecr character(40) COLLATE pg_catalog."default" NOT NULL,
    txt character(80) COLLATE pg_catalog."default" NOT NULL,
    police character(40) COLLATE pg_catalog."default",
    taille integer NOT NULL,
    style character(40) COLLATE pg_catalog."default",
    angle integer,
    idkey integer NOT NULL DEFAULT nextval('plui.habillage_txt_idkey_seq'::regclass),
    the_geom geometry(Point,2154),
    couleur character varying(11) COLLATE pg_catalog."default",
    CONSTRAINT habillage_txt_pkey PRIMARY KEY (idkey)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.habillage_txt
    OWNER to postgres;

GRANT ALL ON TABLE plui.habillage_txt TO postgres;
-- Index: habillage_txt_geom_gist

-- DROP INDEX plui.habillage_txt_geom_gist;

CREATE INDEX habillage_txt_geom_gist
    ON plui.habillage_txt USING gist
    (the_geom)
    TABLESPACE pg_default;
