CREATE TABLE plui.zone_urba_libelle
(
    libelle character varying(12) COLLATE pg_catalog."default" NOT NULL,
    libelong character varying(254) COLLATE pg_catalog."default" NOT NULL,
    datvalid date,
    idkey integer NOT NULL DEFAULT nextval('plui.zone_urba_libelle_idkey_seq'::regclass),
    num_page integer,
    CONSTRAINT zone_urba_libelle_pkey PRIMARY KEY (idkey)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.zone_urba_libelle
    OWNER to postgres;

GRANT ALL ON TABLE plui.zone_urba_libelle TO postgres;
