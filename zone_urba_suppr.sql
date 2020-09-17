-- Table: plui.zone_urba_suppr

-- DROP TABLE plui.zone_urba_suppr;

CREATE TABLE plui.zone_urba_suppr
(
    libelle character varying(12) COLLATE pg_catalog."default" NOT NULL,
    typezone character varying(3) COLLATE pg_catalog."default" NOT NULL,
    destdomi character(2) COLLATE pg_catalog."default" NOT NULL,
    datvalid date,
    idkey integer NOT NULL,
    idkey_du integer NOT NULL,
    the_geom geometry(MultiPolygon,2154),
    CONSTRAINT zone_urba_suppr_pkey PRIMARY KEY (idkey)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.zone_urba_suppr
    OWNER to postgres;

GRANT ALL ON TABLE plui.zone_urba_suppr TO postgres;

-- Index: zone_urba_suppr_the_geom_gist

-- DROP INDEX plui.zone_urba_suppr_the_geom_gist;

CREATE INDEX zone_urba_suppr_the_geom_gist
    ON plui.zone_urba_suppr USING gist
    (the_geom gist_geometry_ops_nd)
    TABLESPACE pg_default;

-- Trigger: zone_urba_suppr

-- DROP TRIGGER zone_urba_suppr ON plui.zone_urba_suppr;

CREATE TRIGGER zone_urba_suppr
    AFTER INSERT OR DELETE
    ON plui.zone_urba_suppr
    FOR EACH ROW
    EXECUTE PROCEDURE plui.zone_urba_suppr(\x);
