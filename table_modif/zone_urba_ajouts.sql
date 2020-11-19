-- Table: plui.zone_urba_ajouts

-- DROP TABLE plui.zone_urba_ajouts;

CREATE TABLE plui.zone_urba_ajouts
(
    libelle character varying(12) COLLATE pg_catalog."default" NOT NULL,
    typezone character varying(3) COLLATE pg_catalog."default" NOT NULL,
    destdomi character(2) COLLATE pg_catalog."default" NOT NULL,
    datvalid date,
    idkey_ajout integer NOT NULL DEFAULT nextval('plui.zone_urba_idkey_seq'::regclass),
    idkey_du integer NOT NULL,
    the_geom geometry(MultiPolygon,2154),
    CONSTRAINT zone_urba_ajouts_pkey PRIMARY KEY (idkey_ajout)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.zone_urba_ajouts
    OWNER to postgres;

GRANT ALL ON TABLE plui.zone_urba_ajouts TO postgres;

-- Index: zone_urba_ajouts_the_geom_gist

-- DROP INDEX plui.zone_urba_ajouts_the_geom_gist;

CREATE INDEX zone_urba_ajouts_the_geom_gist
    ON plui.zone_urba_ajouts USING gist
    (the_geom gist_geometry_ops_nd)
    TABLESPACE pg_default;

-- Trigger: zone_urba_ajout

-- DROP TRIGGER zone_urba_ajout ON plui.zone_urba_ajouts;

CREATE TRIGGER zone_urba_ajout
    AFTER INSERT OR DELETE
    ON plui.zone_urba_ajouts
    FOR EACH ROW
    EXECUTE PROCEDURE plui.zone_urba_ajout(\x);
