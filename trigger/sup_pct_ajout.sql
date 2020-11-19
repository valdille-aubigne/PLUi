-- Trigger: sup_pct_ajout

-- DROP TRIGGER sup_pct_ajout ON plui.sup_pct_ajouts;

CREATE TRIGGER sup_pct_ajout
    AFTER INSERT OR DELETE
    ON plui.sup_pct_ajouts
    FOR EACH ROW
    EXECUTE PROCEDURE plui.sup_pct_ajout();
