CREATE TABLE plui.procedure_urba_type
(
    code character varying(10) COLLATE pg_catalog."default" NOT NULL,
    numero character varying(2) COLLATE pg_catalog."default",
    libelle character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT procedure_urba_type_pkey PRIMARY KEY (code)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.procedure_urba_type
    OWNER to postgres;

GRANT ALL ON TABLE plui.procedure_urba_type TO postgres;
