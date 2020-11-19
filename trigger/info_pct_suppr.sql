-- Trigger: info_pct_suppr

-- DROP TRIGGER info_pct_suppr ON plui.info_pct_suppr;

CREATE TRIGGER info_pct_suppr
    AFTER INSERT OR DELETE
    ON plui.info_pct_suppr
    FOR EACH ROW
    EXECUTE PROCEDURE plui.info_pct_suppr();
