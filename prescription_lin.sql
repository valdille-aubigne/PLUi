-- Table: plui.prescription_lin

-- DROP TABLE plui.prescription_lin;

CREATE TABLE plui.prescription_lin
(
    libelle character varying(254) COLLATE pg_catalog."default" NOT NULL,
    txt character varying(10) COLLATE pg_catalog."default",
    typepsc character(2) COLLATE pg_catalog."default" NOT NULL,
    stypepsc character(2) COLLATE pg_catalog."default" NOT NULL,
    nomfic character varying(80) COLLATE pg_catalog."default",
    urlfic character varying(254) COLLATE pg_catalog."default",
    datvalid date,
    idkey integer NOT NULL DEFAULT nextval('plui.prescription_lin_idkey_seq'::regclass),
    the_geom geometry(MultiLineString,2154),
    CONSTRAINT prescription_lin_pkey PRIMARY KEY (idkey)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.prescription_lin
    OWNER to postgres;

GRANT ALL ON TABLE plui.prescription_lin TO postgres;
-- Index: prescription_lin_geom_gist

-- DROP INDEX plui.prescription_lin_geom_gist;

CREATE INDEX prescription_lin_geom_gist
    ON plui.prescription_lin USING gist
    (the_geom)
    TABLESPACE pg_default;
