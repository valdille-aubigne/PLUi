-- Table: plui.zone_urba_libelle_suppr

-- DROP TABLE plui.zone_urba_libelle_suppr;

CREATE TABLE plui.zone_urba_libelle_suppr
(
    libelle character varying(12) COLLATE pg_catalog."default" NOT NULL,
    libelong character varying(254) COLLATE pg_catalog."default" NOT NULL,
    datvalid date,
    idkey integer NOT NULL,
    idkey_du integer NOT NULL,
    num_page integer,
    CONSTRAINT zone_urba_libelle_suppr_pkey PRIMARY KEY (idkey)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.zone_urba_libelle_suppr
    OWNER to postgres;

GRANT ALL ON TABLE plui.zone_urba_libelle_suppr TO postgres;

-- Trigger: zone_urba_libelle_suppr

-- DROP TRIGGER zone_urba_libelle_suppr ON plui.zone_urba_libelle_suppr;

CREATE TRIGGER zone_urba_libelle_suppr
    AFTER INSERT OR DELETE
    ON plui.zone_urba_libelle_suppr
    FOR EACH ROW
    EXECUTE PROCEDURE plui.zone_urba_libelle_suppr(\x);
