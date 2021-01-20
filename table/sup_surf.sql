-- Table: plui.sup_surf

-- DROP TABLE plui.sup_surf;

CREATE TABLE plui.sup_surf
(
    idkey integer NOT NULL DEFAULT nextval('plui.sup_surf_idkey_seq'::regclass),
    libsup character varying(250) COLLATE pg_catalog."default",
    categorie character varying(6) COLLATE pg_catalog."default",
    infos character varying(254) COLLATE pg_catalog."default",
    regles character varying(100) COLLATE pg_catalog."default",
    datappro character varying(14) COLLATE pg_catalog."default",
    nomfic character varying(80) COLLATE pg_catalog."default",
    urlfic character varying(254) COLLATE pg_catalog."default",
    datvalid character varying(14) COLLATE pg_catalog."default",
    the_geom geometry(MultiPolygon,2154),
    CONSTRAINT sup_surf_pkey PRIMARY KEY (idkey)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.sup_surf
    OWNER to postgres;

GRANT ALL ON TABLE plui.sup_surf TO postgres;
-- Index: sup_surf_categorie_1548760164904

-- DROP INDEX plui.sup_surf_categorie_1548760164904;

CREATE INDEX sup_surf_categorie_1548760164904
    ON plui.sup_surf USING btree
    (categorie COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: sup_surf_infos_1548760164907

-- DROP INDEX plui.sup_surf_infos_1548760164907;

CREATE INDEX sup_surf_infos_1548760164907
    ON plui.sup_surf USING btree
    (infos COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: sup_surf_the_geom_1548760164909

-- DROP INDEX plui.sup_surf_the_geom_1548760164909;

CREATE INDEX sup_surf_the_geom_1548760164909
    ON plui.sup_surf USING gist
    (the_geom)
    TABLESPACE pg_default;
