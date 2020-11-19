-- Trigger: prescription_pct

-- DROP TRIGGER prescription_pct ON plui.prescription_pct;

CREATE TRIGGER prescription_pct
    AFTER INSERT OR DELETE
    ON plui.prescription_pct
    FOR EACH ROW
    EXECUTE PROCEDURE plui.prescription_pct();
