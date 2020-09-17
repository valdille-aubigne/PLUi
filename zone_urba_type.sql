CREATE TABLE plui.zone_urba_type
(
    code character varying(10) COLLATE pg_catalog."default" NOT NULL,
    libelle character varying(50) COLLATE pg_catalog."default" NOT NULL,
    definition character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT zone_urba_type_pkey PRIMARY KEY (code)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.zone_urba_type
    OWNER to postgres;

GRANT ALL ON TABLE plui.zone_urba_type TO postgres;
