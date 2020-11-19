-- Trigger: sup_pct

-- DROP TRIGGER sup_pct ON plui.sup_pct;

CREATE TRIGGER sup_pct
    AFTER INSERT OR DELETE
    ON plui.sup_pct
    FOR EACH ROW
    EXECUTE PROCEDURE plui.sup_pct();
