-- Table: plui.zone_urba_libelle_ajouts

-- DROP TABLE plui.zone_urba_libelle_ajouts;

CREATE TABLE plui.zone_urba_libelle_ajouts
(
    libelle character varying(12) COLLATE pg_catalog."default" NOT NULL,
    libelong character varying(254) COLLATE pg_catalog."default" NOT NULL,
    datvalid date,
    idkey_ajout integer NOT NULL DEFAULT nextval('plui.zone_urba_libelle_idkey_seq'::regclass),
    idkey_du integer NOT NULL,
    num_page integer,
    CONSTRAINT zone_urba_libelle_ajouts_pkey PRIMARY KEY (idkey_ajout)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.zone_urba_libelle_ajouts
    OWNER to postgres;

GRANT ALL ON TABLE plui.zone_urba_libelle_ajouts TO postgres;

-- Trigger: zone_urba_libelle_ajout

-- DROP TRIGGER zone_urba_libelle_ajout ON plui.zone_urba_libelle_ajouts;

CREATE TRIGGER zone_urba_libelle_ajout
    AFTER INSERT OR DELETE
    ON plui.zone_urba_libelle_ajouts
    FOR EACH ROW
    EXECUTE PROCEDURE plui.zone_urba_libelle_ajout(\x);
