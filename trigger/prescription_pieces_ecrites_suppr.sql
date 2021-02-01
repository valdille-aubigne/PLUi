-- Trigger: prescription_pieces_ecrites_suppr

-- DROP TRIGGER prescription_pieces_ecrites_suppr ON plui.prescription_pieces_ecrites_suppr;

CREATE TRIGGER prescription_pieces_ecrites_suppr
    AFTER INSERT OR DELETE OR UPDATE
    ON plui.prescription_pieces_ecrites_suppr
    FOR EACH ROW
    EXECUTE PROCEDURE plui.prescription_pieces_ecrites_suppr();
