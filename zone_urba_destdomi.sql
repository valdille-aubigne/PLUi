-- Table: plui.zone_urba_destdomi

-- DROP TABLE plui.zone_urba_destdomi;

CREATE TABLE plui.zone_urba_destdomi
(
    code character varying(10) COLLATE pg_catalog."default" NOT NULL,
    libelle character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT zone_urba_destdomi_pkey PRIMARY KEY (code)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.zone_urba_destdomi
    OWNER to postgres;

GRANT ALL ON TABLE plui.zone_urba_destdomi TO postgres;
