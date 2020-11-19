-- Table: plui.prescription_urba_type

-- DROP TABLE plui.prescription_urba_type;

CREATE TABLE plui.prescription_urba_type
(
    code character varying(10) COLLATE pg_catalog."default" NOT NULL,
    sous_code character varying(10) COLLATE pg_catalog."default" NOT NULL,
    libelle character varying(255) COLLATE pg_catalog."default" NOT NULL,
    ref_leg_cu character varying(50) COLLATE pg_catalog."default",
    ref_regl_cu character varying(50) COLLATE pg_catalog."default",
    CONSTRAINT prescription_urba_type_pkey PRIMARY KEY (code, sous_code)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.prescription_urba_type
    OWNER to postgres;

GRANT ALL ON TABLE plui.prescription_urba_type TO postgres;
