-- Table: plui.prescription_pct_suppr

-- DROP TABLE plui.prescription_pct_suppr;

CREATE TABLE plui.prescription_pct_suppr
(
    libelle character varying(254) COLLATE pg_catalog."default" NOT NULL,
    txt character varying(10) COLLATE pg_catalog."default",
    typepsc character(2) COLLATE pg_catalog."default" NOT NULL,
    stypepsc character(2) COLLATE pg_catalog."default" NOT NULL,
    nomfic character varying(80) COLLATE pg_catalog."default",
    urlfic character varying(254) COLLATE pg_catalog."default",
    datvalid date,
    idkey integer NOT NULL,
    idkey_du integer NOT NULL,
    the_geom geometry(Point,2154),
    CONSTRAINT prescription_pct_suppr_pkey PRIMARY KEY (idkey)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.prescription_pct_suppr
    OWNER to postgres;

GRANT ALL ON TABLE plui.prescription_pct_suppr TO postgres;

GRANT UPDATE, INSERT, DELETE, SELECT ON TABLE plui.prescription_pct_suppr TO urba;

-- Index: prescription_pct_suppr_geom_gist

-- DROP INDEX plui.prescription_pct_suppr_geom_gist;

CREATE INDEX prescription_pct_suppr_geom_gist
    ON plui.prescription_pct_suppr USING gist
    (the_geom)
    TABLESPACE pg_default;

-- Trigger: prescription_pct_suppr

-- DROP TRIGGER prescription_pct_suppr ON plui.prescription_pct_suppr;

CREATE TRIGGER prescription_pct_suppr
    AFTER INSERT OR DELETE
    ON plui.prescription_pct_suppr
    FOR EACH ROW
    EXECUTE PROCEDURE plui.prescription_pct_suppr(\x);
