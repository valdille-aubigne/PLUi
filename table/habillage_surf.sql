CREATE TABLE plui.habillage_surf
(
    nattrac character(40) COLLATE pg_catalog."default" NOT NULL,
    idurba character varying(30) COLLATE pg_catalog."default" NOT NULL,
    idkey integer NOT NULL DEFAULT nextval('plui.habillage_surf_idkey_seq'::regclass),
    the_geom geometry(MultiPolygon,2154),
    couleur character varying(11) COLLATE pg_catalog."default",
    CONSTRAINT habillage_surf_pkey PRIMARY KEY (idkey)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.habillage_surf
    OWNER to postgres;

GRANT ALL ON TABLE plui.habillage_surf TO postgres;
-- Index: habillage_surf_geom_gist

-- DROP INDEX plui.habillage_surf_geom_gist;

CREATE INDEX habillage_surf_geom_gist
    ON plui.habillage_surf USING gist
    (the_geom)
    TABLESPACE pg_default;
