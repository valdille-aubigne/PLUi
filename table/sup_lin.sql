CREATE TABLE plui.sup_lin
(
    idkey integer NOT NULL DEFAULT nextval('plui.sup_lin_idkey_seq'::regclass),
    libsup character varying(250) COLLATE pg_catalog."default",
    categorie character varying(6) COLLATE pg_catalog."default",
    infos character varying(254) COLLATE pg_catalog."default",
    regles character varying(100) COLLATE pg_catalog."default",
    datappro character varying(14) COLLATE pg_catalog."default",
    nomfic character varying(80) COLLATE pg_catalog."default",
    urlfic character varying(254) COLLATE pg_catalog."default",
    datvalid character varying(14) COLLATE pg_catalog."default",
    the_geom geometry(MultiLineString,2154),
    CONSTRAINT sup_lin_pkey PRIMARY KEY (idkey)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.sup_lin
    OWNER to postgres;

GRANT ALL ON TABLE plui.sup_lin TO postgres;
-- Index: sup_lin_categorie_1548760164896

-- DROP INDEX plui.sup_lin_categorie_1548760164896;

CREATE INDEX sup_lin_categorie_1548760164896
    ON plui.sup_lin USING btree
    (categorie COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: sup_lin_infos_1548760164900

-- DROP INDEX plui.sup_lin_infos_1548760164900;

CREATE INDEX sup_lin_infos_1548760164900
    ON plui.sup_lin USING btree
    (infos COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: sup_lin_the_geom_1548760164902

-- DROP INDEX plui.sup_lin_the_geom_1548760164902;

CREATE INDEX sup_lin_the_geom_1548760164902
    ON plui.sup_lin USING gist
    (the_geom)
    TABLESPACE pg_default;
