-- Table: plui.doc_urba

-- DROP TABLE plui.doc_urba;

CREATE TABLE plui.doc_urba
(
    idurba character(30) COLLATE pg_catalog."default" NOT NULL,
    typedoc character(4) COLLATE pg_catalog."default" NOT NULL,
    etat character(2) COLLATE pg_catalog."default" NOT NULL DEFAULT '01'::bpchar,
    nomproc character varying(10) COLLATE pg_catalog."default" DEFAULT 'E'::character varying,
    datappro date NOT NULL,
    datefin date,
    siren character(9) COLLATE pg_catalog."default",
    nomreg character(80) COLLATE pg_catalog."default",
    urlreg character(254) COLLATE pg_catalog."default",
    nomplan character(80) COLLATE pg_catalog."default",
    urlplan character(254) COLLATE pg_catalog."default",
    urlpe character(254) COLLATE pg_catalog."default",
    urlmd character(254) COLLATE pg_catalog."default",
    siteweb character(254) COLLATE pg_catalog."default",
    typeref character(2) COLLATE pg_catalog."default",
    dateref date NOT NULL,
    idkey integer NOT NULL DEFAULT nextval('plui.doc_urba_idkey_seq'::regclass),
    the_geom geometry(Geometry,2154),
    zone_urba integer[],
    zone_urba_libelle integer[],
    prescription_surf integer[],
    prescription_pct integer[],
    prescription_lin integer[],
    info_pct integer[],
    info_surf integer[],
    info_lin integer[],
    prescription_pieces_ecrites integer[],
    sup_surf integer[],
    sup_pct integer[],
    sup_lin integer[],
    CONSTRAINT doc_urba_pkey PRIMARY KEY (idkey)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.doc_urba
    OWNER to postgres;

GRANT ALL ON TABLE plui.doc_urba TO postgres;

-- Index: doc_urba_geom_1475053050421

-- DROP INDEX plui.doc_urba_geom_1475053050421;

CREATE INDEX doc_urba_geom_1475053050421
    ON plui.doc_urba USING gist
    (the_geom)
    TABLESPACE pg_default;

-- Trigger: doc_urba

-- DROP TRIGGER doc_urba ON plui.doc_urba;

CREATE TRIGGER doc_urba
    BEFORE INSERT OR UPDATE
    ON plui.doc_urba
    FOR EACH ROW
    EXECUTE PROCEDURE plui.doc_urba();

-- Trigger: vues_urba

-- DROP TRIGGER vues_urba ON plui.doc_urba;

CREATE TRIGGER vues_urba
    AFTER INSERT OR DELETE OR UPDATE
    ON plui.doc_urba
    FOR EACH ROW
    EXECUTE PROCEDURE plui.vues_urba();
