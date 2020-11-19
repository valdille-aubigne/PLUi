-- Trigger: prescription_pct_suppr

-- DROP TRIGGER prescription_pct_suppr ON plui.prescription_pct_suppr;

CREATE TRIGGER prescription_pct_suppr
    AFTER INSERT OR DELETE
    ON plui.prescription_pct_suppr
    FOR EACH ROW
    EXECUTE PROCEDURE plui.prescription_pct_suppr();
