-- Trigger: prescription_lin_suppr

-- DROP TRIGGER prescription_lin_suppr ON plui.prescription_lin_suppr;

CREATE TRIGGER prescription_lin_suppr
    AFTER INSERT OR DELETE OR UPDATE
    ON plui.prescription_lin_suppr
    FOR EACH ROW
    EXECUTE PROCEDURE plui.prescription_lin_suppr();
