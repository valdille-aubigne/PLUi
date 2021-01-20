-- Table: plui.info_surf

-- DROP TABLE plui.info_surf;

CREATE TABLE plui.info_surf
(
    libelle character varying(254) COLLATE pg_catalog."default" NOT NULL,
    txt character(10) COLLATE pg_catalog."default",
    typeinf character(2) COLLATE pg_catalog."default" NOT NULL,
    stypeinf character(2) COLLATE pg_catalog."default" NOT NULL,
    nomfic character(80) COLLATE pg_catalog."default",
    urlfic character(254) COLLATE pg_catalog."default",
    datvalid date,
    idkey integer NOT NULL DEFAULT nextval('plui.info_surf_idkey_seq'::regclass),
    the_geom geometry(MultiPolygon,2154),
    CONSTRAINT info_surf_pkey PRIMARY KEY (idkey)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.info_surf
    OWNER to postgres;

GRANT ALL ON TABLE plui.info_surf TO postgres;
-- Index: info_surf_geom_gist

-- DROP INDEX plui.info_surf_geom_gist;

CREATE INDEX info_surf_geom_gist
    ON plui.info_surf USING gist
    (the_geom)
    TABLESPACE pg_default;
