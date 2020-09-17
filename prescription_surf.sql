-- Table: plui.prescription_surf

-- DROP TABLE plui.prescription_surf;

CREATE TABLE plui.prescription_surf
(
    libelle character varying(254) COLLATE pg_catalog."default" NOT NULL,
    txt character varying(10) COLLATE pg_catalog."default",
    typepsc character(2) COLLATE pg_catalog."default" NOT NULL,
    stypepsc character(2) COLLATE pg_catalog."default" NOT NULL,
    nomfic character varying(80) COLLATE pg_catalog."default",
    urlfic character varying(254) COLLATE pg_catalog."default",
    datvalid date,
    idkey integer NOT NULL DEFAULT nextval('plui.prescription_surf_idkey_seq'::regclass),
    the_geom geometry(MultiPolygon,2154),
    CONSTRAINT prescription_surf_pkey PRIMARY KEY (idkey)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.prescription_surf
    OWNER to postgres;

GRANT ALL ON TABLE plui.prescription_surf TO postgres;

-- Index: prescription_surf_geom_gist

-- DROP INDEX plui.prescription_surf_geom_gist;

CREATE INDEX prescription_surf_geom_gist
    ON plui.prescription_surf USING gist
    (the_geom)
    TABLESPACE pg_default;
