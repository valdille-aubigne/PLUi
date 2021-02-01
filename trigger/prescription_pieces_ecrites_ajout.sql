-- Trigger: prescription_pieces_ecrites_ajout

-- DROP TRIGGER prescription_pieces_ecrites_ajout ON plui.prescription_pieces_ecrites_ajouts;

CREATE TRIGGER prescription_pieces_ecrites_ajout
    AFTER INSERT OR DELETE OR UPDATE
    ON plui.prescription_pieces_ecrites_ajouts
    FOR EACH ROW
    EXECUTE PROCEDURE plui.prescription_pieces_ecrites_ajout();
