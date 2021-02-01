-- Trigger: prescription_pct_ajout

-- DROP TRIGGER prescription_pct_ajout ON plui.prescription_pct_ajouts;

CREATE TRIGGER prescription_pct_ajout
    AFTER INSERT OR DELETE OR UPDATE
    ON plui.prescription_pct_ajouts
    FOR EACH ROW
    EXECUTE PROCEDURE plui.prescription_pct_ajout();
