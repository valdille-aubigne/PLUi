CREATE TABLE plui.info_lin
(
    libelle character varying(254) COLLATE pg_catalog."default" NOT NULL,
    txt character varying(10) COLLATE pg_catalog."default",
    typeinf character(2) COLLATE pg_catalog."default" NOT NULL,
    stypeinf character(2) COLLATE pg_catalog."default" NOT NULL,
    nomfic character varying(80) COLLATE pg_catalog."default",
    urlfic character varying(254) COLLATE pg_catalog."default",
    datvalid date,
    idkey integer NOT NULL DEFAULT nextval('plui.info_lin_idkey_seq'::regclass),
    the_geom geometry(MultiLineString,2154),
    CONSTRAINT info_lin_pkey PRIMARY KEY (idkey)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;
