-- Trigger: sup_pct_suppr

-- DROP TRIGGER sup_pct_suppr ON plui.sup_pct_suppr;

CREATE TRIGGER sup_pct_suppr
    AFTER INSERT OR DELETE OR UPDATE
    ON plui.sup_pct_suppr
    FOR EACH ROW
    EXECUTE PROCEDURE plui.sup_pct_suppr();
