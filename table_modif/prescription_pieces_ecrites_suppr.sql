-- Table: plui.prescription_pieces_ecrites_suppr

-- DROP TABLE plui.prescription_pieces_ecrites_suppr;

CREATE TABLE plui.prescription_pieces_ecrites_suppr
(
    typepsc character(2) COLLATE pg_catalog."default",
    stypepsc character(2) COLLATE pg_catalog."default",
    code_commune character varying(10) COLLATE pg_catalog."default",
    idkey integer NOT NULL,
    idkey_du integer NOT NULL,
    piece_ecrite character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT prescription_pieces_ecrites_suppr_pkey PRIMARY KEY (idkey)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE plui.prescription_pieces_ecrites_suppr
    OWNER to postgres;

GRANT ALL ON TABLE plui.prescription_pieces_ecrites_suppr TO postgres;
