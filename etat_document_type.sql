-- Table: plui.etat_document_type

-- DROP TABLE plui.etat_document_type;

CREATE TABLE plui.etat_document_type
(
    code character varying(10) COLLATE pg_catalog."default" NOT NULL,
    libelle character varying(50) COLLATE pg_catalog."default" NOT NULL,
    definition character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT etat_document_type_pkey PRIMARY KEY (code)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.etat_document_type
    OWNER to postgres;

GRANT ALL ON TABLE plui.etat_document_type TO postgres;
