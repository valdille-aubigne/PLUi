-- Table: plui.prescription_pieces_ecrites_ajouts

-- DROP TABLE plui.prescription_pieces_ecrites_ajouts;

CREATE TABLE plui.prescription_pieces_ecrites_ajouts
(
    typepsc character(2) COLLATE pg_catalog."default",
    stypepsc character(2) COLLATE pg_catalog."default",
    code_commune character varying(10) COLLATE pg_catalog."default",
    idkey_ajout integer NOT NULL DEFAULT nextval('plui.prescription_pieces_ecrites_idkey_seq'::regclass),
    idkey_du integer NOT NULL,
    piece_ecrite character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT prescription_pieces_ecrites_ajouts_pkey PRIMARY KEY (idkey_ajout)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.prescription_pieces_ecrites_ajouts
    OWNER to postgres;

GRANT ALL ON TABLE plui.prescription_pieces_ecrites_ajouts TO postgres;
