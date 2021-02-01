-- Trigger: prescription_lin_ajout

-- DROP TRIGGER prescription_lin_ajout ON plui.prescription_lin_ajouts;

CREATE TRIGGER prescription_lin_ajout
    AFTER INSERT OR DELETE OR UPDATE
    ON plui.prescription_lin_ajouts
    FOR EACH ROW
    EXECUTE PROCEDURE plui.prescription_lin_ajout();
