-- Table: plui.prescription_pct_ajouts

-- DROP TABLE plui.prescription_pct_ajouts;

CREATE TABLE plui.prescription_pct_ajouts
(
    libelle character varying(254) COLLATE pg_catalog."default" NOT NULL,
    txt character varying(10) COLLATE pg_catalog."default",
    typepsc character(2) COLLATE pg_catalog."default" NOT NULL,
    stypepsc character(2) COLLATE pg_catalog."default" NOT NULL,
    nomfic character varying(80) COLLATE pg_catalog."default",
    urlfic character varying(254) COLLATE pg_catalog."default",
    datvalid date,
    idkey_ajout integer NOT NULL DEFAULT nextval('plui.prescription_pct_idkey_seq'::regclass),
    idkey_du integer NOT NULL,
    the_geom geometry(Point,2154),
    CONSTRAINT prescription_pct_ajouts_pkey PRIMARY KEY (idkey_ajout)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.prescription_pct_ajouts
    OWNER to postgres;

GRANT ALL ON TABLE plui.prescription_pct_ajouts TO postgres;

-- Index: prescription_pct_ajouts_geom_gist

-- DROP INDEX plui.prescription_pct_ajouts_geom_gist;

CREATE INDEX prescription_pct_ajouts_geom_gist
    ON plui.prescription_pct_ajouts USING gist
    (the_geom)
    TABLESPACE pg_default;

-- Trigger: prescription_pct_ajout

-- DROP TRIGGER prescription_pct_ajout ON plui.prescription_pct_ajouts;

CREATE TRIGGER prescription_pct_ajout
    AFTER INSERT OR DELETE
    ON plui.prescription_pct_ajouts
    FOR EACH ROW
    EXECUTE PROCEDURE plui.prescription_pct_ajout(\x);
