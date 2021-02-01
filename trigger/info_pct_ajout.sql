-- Trigger: info_pct_ajout

-- DROP TRIGGER info_pct_ajout ON plui.info_pct_ajouts;

CREATE TRIGGER info_pct_ajout
    AFTER INSERT OR DELETE OR UPDATE
    ON plui.info_pct_ajouts
    FOR EACH ROW
    EXECUTE PROCEDURE plui.info_pct_ajout();
