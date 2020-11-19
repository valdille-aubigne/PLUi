-- Table: plui.zone_urba

-- DROP TABLE plui.zone_urba;

CREATE TABLE plui.zone_urba
(
    libelle character varying(12) COLLATE pg_catalog."default" NOT NULL,
    typezone character varying(3) COLLATE pg_catalog."default" NOT NULL,
    destdomi character(2) COLLATE pg_catalog."default" NOT NULL,
    datvalid date,
    idkey integer NOT NULL DEFAULT nextval('plui.zone_urba_idkey_seq'::regclass),
    the_geom geometry(MultiPolygon,2154),
    CONSTRAINT zone_urba_pkey PRIMARY KEY (idkey)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.zone_urba
    OWNER to postgres;

GRANT ALL ON TABLE plui.zone_urba TO postgres;

-- Index: zone_urba_the_geom_gist

-- DROP INDEX plui.zone_urba_the_geom_gist;

CREATE INDEX zone_urba_the_geom_gist
    ON plui.zone_urba USING gist
    (the_geom gist_geometry_ops_nd)
    TABLESPACE pg_default;
