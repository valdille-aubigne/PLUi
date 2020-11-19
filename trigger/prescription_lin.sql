-- Trigger: prescription_lin

-- DROP TRIGGER prescription_lin ON plui.prescription_lin;

CREATE TRIGGER prescription_lin
    AFTER INSERT OR DELETE
    ON plui.prescription_lin
    FOR EACH ROW
    EXECUTE PROCEDURE plui.prescription_lin();
