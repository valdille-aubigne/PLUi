CREATE TABLE plui.info_urba_type
(
    code character varying(10) COLLATE pg_catalog."default" NOT NULL,
    sous_code character varying(10) COLLATE pg_catalog."default" NOT NULL,
    libelle character varying(255) COLLATE pg_catalog."default" NOT NULL,
    ref_leg_cu character varying(50) COLLATE pg_catalog."default",
    ref_regl_cu character varying(50) COLLATE pg_catalog."default",
    CONSTRAINT info_urba_type_pkey PRIMARY KEY (code, sous_code)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.info_urba_type
    OWNER to postgres;

GRANT ALL ON TABLE plui.info_urba_type TO postgres;
