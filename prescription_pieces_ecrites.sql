-- Table: plui.prescription_pieces_ecrites

-- DROP TABLE plui.prescription_pieces_ecrites;

CREATE TABLE plui.prescription_pieces_ecrites
(
    typepsc character(2) COLLATE pg_catalog."default",
    stypepsc character(2) COLLATE pg_catalog."default",
    code_commune character varying(10) COLLATE pg_catalog."default",
    idkey integer NOT NULL DEFAULT nextval('plui.prescription_pieces_ecrites_idkey_seq'::regclass),
    piece_ecrite character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT prescription_pieces_ecrites_pkey PRIMARY KEY (idkey)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.prescription_pieces_ecrites
    OWNER to postgres;

GRANT ALL ON TABLE plui.prescription_pieces_ecrites TO postgres;
