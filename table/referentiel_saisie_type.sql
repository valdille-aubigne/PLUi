-- Table: plui.referentiel_saisie_type

-- DROP TABLE plui.referentiel_saisie_type;

CREATE TABLE plui.referentiel_saisie_type
(
    code character varying(10) COLLATE pg_catalog."default" NOT NULL,
    libelle character varying(50) COLLATE pg_catalog."default" NOT NULL,
    definition character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT referentiel_saisie_type_pkey PRIMARY KEY (code)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.referentiel_saisie_type
    OWNER to postgres;

GRANT ALL ON TABLE plui.referentiel_saisie_type TO postgres;
