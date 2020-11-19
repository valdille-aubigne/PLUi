-- Trigger: info_pct

-- DROP TRIGGER info_pct ON plui.info_pct;

CREATE TRIGGER info_pct
    AFTER INSERT OR DELETE
    ON plui.info_pct
    FOR EACH ROW
    EXECUTE PROCEDURE plui.info_pct();
